import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../models/shift_model.dart';
import '../../../api/shift_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../main.dart';


class QRScannerWidget extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerWidget({Key? key, required this.onScan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    return SizedBox(
      height: 200,
      child: QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          controller.scannedDataStream.listen((scanData) {
            if (scanData.code != null) {
              onScan(scanData.code!);
            }
          });
        },
      ),
    );
  }
}

class ShiftsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ShiftModel> shifts = <ShiftModel>[].obs;
  RxString viewMode = 'daily'.obs; // 'daily' or 'weekly'
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> weekStartDate = DateTime.now().obs;
  Rx<DateTime> weekEndDate = DateTime.now().add(const Duration(days: 6)).obs;

  // Map to track number of shifts per day
  RxMap<String, int> shiftsPerDay = <String, int>{}.obs;

  // Current month for calendar view
  Rx<DateTime> currentMonth = DateTime.now().obs;

  // Check-in/out related variables
  RxBool isCheckingIn = false.obs;
  RxBool isCheckingOut = false.obs;
  RxString currentAttendanceId = ''.obs;
  RxBool isLocationPermissionGranted = false.obs;
  RxBool isLocationServiceEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShifts();
    fetchMonthShifts();
    checkLocationPermission();
  }

  void toggleViewMode() {
    final newMode = viewMode.value == 'daily' ? 'weekly' : 'daily';
    viewMode.value = newMode;

    // Reset dates when switching views
    if (newMode == 'weekly') {
      // Set to current week
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      weekStartDate.value = monday;
      weekEndDate.value = monday.add(const Duration(days: 6));
    } else {
      // Set to today for daily view
      selectedDate.value = DateTime.now();
    }

    fetchShifts();
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchShifts();
  }

  void setWeekDates(DateTime start, DateTime end) {
    weekStartDate.value = start;
    weekEndDate.value = end;
    fetchShifts();
  }

  void setCurrentMonth(DateTime month) {
    currentMonth.value = month;
    fetchMonthShifts();
  }

  Future<void> fetchShifts() async {
    isLoading(true);
    try {
      String startDate;
      String endDate;

      if (viewMode.value == 'daily') {
        // Format for daily view - use the selected date
        startDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
        endDate = startDate;
      } else {
        // Format for weekly view - use the week start and end dates
        startDate = DateFormat('yyyy-MM-dd').format(weekStartDate.value);
        endDate = DateFormat('yyyy-MM-dd').format(weekEndDate.value);
      }

      final fetchedShifts = await ShiftServiceApis.getShifts(
        startDate: startDate,
        endDate: endDate,
      );

      if (viewMode.value == 'daily') {
        // Filter shifts based on recurrence rules and selected date for daily view
        final filteredShifts = fetchedShifts.where((shift) {
          // Skip inactive shifts
          if (shift.status != 'Active') return false;

          // Check if the shift's date range includes the selected date
          final shiftStartDate = DateTime(
            shift.startDate.year,
            shift.startDate.month,
            shift.startDate.day,
          );

          final shiftEndDate = shift.endDate != null
              ? DateTime(
                  shift.endDate!.year,
                  shift.endDate!.month,
                  shift.endDate!.day,
                )
              : null;

          final selectedDateTime = DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
          );

          // Check if selected date is within the shift's date range
          final isWithinDateRange =
              selectedDateTime.isAtSameMomentAs(shiftStartDate) ||
                  (shiftEndDate != null &&
                      (selectedDateTime.isAfter(shiftStartDate) &&
                          selectedDateTime.isBefore(
                              shiftEndDate.add(const Duration(days: 1)))));

          if (!isWithinDateRange) return false;

          // For daily recurrence, show if within date range
          if (shift.recurrenceRule == 'Daily') {
            return true;
          }

          // For weekly recurrence, check if the selected day is in weekDays
          if (shift.recurrenceRule == 'Weekly') {
            final selectedDayName =
                DateFormat('EEEE').format(selectedDate.value);
            return shift.weekDays.contains(selectedDayName);
          }

          // For non-recurring shifts, only show on the exact start date
          return selectedDateTime.isAtSameMomentAs(shiftStartDate);
        }).toList();

        shifts.value = filteredShifts;
      } else {
        // For weekly view, show all shifts within the date range
        shifts.value = fetchedShifts;
      }
    } catch (e) {
      log('fetchShifts Error: $e');
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMonthShifts() async {
    try {
      // Get first and last day of the current month
      final firstDayOfMonth =
          DateTime(currentMonth.value.year, currentMonth.value.month, 1);
      final lastDayOfMonth =
          DateTime(currentMonth.value.year, currentMonth.value.month + 1, 0);

      final startDate = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
      final endDate = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);

      final monthShifts = await ShiftServiceApis.getShifts(
        startDate: startDate,
        endDate: endDate,
      );

      // Reset the shifts per day map
      shiftsPerDay.clear();

      // Process each shift and count occurrences per day
      for (var shift in monthShifts) {
        _processShiftForCalendar(shift, firstDayOfMonth, lastDayOfMonth);
      }
    } catch (e) {
      log('fetchMonthShifts Error: $e');
      toast(e.toString());
    }
  }

  void _processShiftForCalendar(
      ShiftModel shift, DateTime monthStart, DateTime monthEnd) {
    if (shift.status != 'Active') return;

    final startDate = shift.startDate;
    final endDate = shift.endDate;
    final recurrenceRule = shift.recurrenceRule;
    final weekDays = shift.weekDays;

    // If no end date, use month end as the limit
    final effectiveEndDate = endDate != null ? endDate : monthEnd;

    // Process based on recurrence rule
    if (recurrenceRule == 'Daily') {
      // Add to all days between start and end date
      DateTime currentDate = startDate;
      while (currentDate.isBefore(effectiveEndDate) ||
          currentDate.isAtSameMomentAs(effectiveEndDate)) {
        if (currentDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            currentDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
          _incrementShiftCountForDate(currentDate);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (recurrenceRule == 'Weekly') {
      // Add only to specified weekdays between start and end date
      DateTime currentDate = startDate;
      while (currentDate.isBefore(effectiveEndDate) ||
          currentDate.isAtSameMomentAs(effectiveEndDate)) {
        if (currentDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            currentDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
          // Get the weekday name in the correct format
          final dayName = DateFormat('EEEE').format(currentDate);
          // Check if this day is in the weekDays list
          if (weekDays.contains(dayName)) {
            _incrementShiftCountForDate(currentDate);
          }
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else {
      // For non-recurring shifts, just add to the specific date
      if (startDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          startDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
        _incrementShiftCountForDate(startDate);
      }
    }
  }

  void _incrementShiftCountForDate(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    shiftsPerDay[dateKey] = (shiftsPerDay[dateKey] ?? 0) + 1;
  }

  Future<void> addShift(ShiftModel shift) async {
    isLoading(true);
    try {
      final success = await ShiftServiceApis.addShift(shift);

      if (success) {
        toast('Shift added successfully');
        fetchShifts();
        fetchMonthShifts(); // Refresh calendar data
      } else {
        toast('Failed to add shift');
      }
    } catch (e) {
      log('addShift Error: $e');
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateShift(ShiftModel shift) async {
    isLoading(true);
    try {
      final success = await ShiftServiceApis.updateShift(shift);

      if (success) {
        toast('Shift updated successfully');
        fetchShifts();
        fetchMonthShifts(); // Refresh calendar data
      } else {
        toast('Failed to update shift');
      }
    } catch (e) {
      log('updateShift Error: $e');
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteShift(String id) async {
    isLoading(true);
    try {
      final success = await ShiftServiceApis.deleteShift(id);

      if (success) {
        toast('Shift deleted successfully');
        fetchShifts();
        fetchMonthShifts(); // Refresh calendar data
      } else {
        toast('Failed to delete shift');
      }
    } catch (e) {
      log('deleteShift Error: $e');
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> checkLocationPermission() async {
    try {
      // Check if location services are enabled
      isLocationServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
      
      if (!isLocationServiceEnabled.value) {
        toast('Please enable location services');
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      isLocationPermissionGranted.value = permission == LocationPermission.always || 
                                         permission == LocationPermission.whileInUse;
      
      if (!isLocationPermissionGranted.value) {
        toast('Location permission is required for check-in/out');
        return false;
      }

      return true;
    } catch (e) {
      log('checkLocationPermission Error: $e');
      toast('Error checking location permission');
      return false;
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      if (!isLocationPermissionGranted.value) {
        final hasPermission = await checkLocationPermission();
        if (!hasPermission) return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      log('getCurrentLocation Error: $e');
      toast('Error getting current location');
      return null;
    }
  }

  Future<void> handleCheckIn(ShiftModel shift, {String? qrCode}) async {
    if (isCheckingIn.value) return;
    
    isCheckingIn(true);
    try {
      final position = await getCurrentLocation();
      if (position == null) {
        toast('Could not get current location');
        return;
      }

      final success = await ShiftServiceApis.checkIn(
        userId: loginUserData.value.idString,
        shiftId: shift.id,
        checkInLat: position.latitude,
        checkInLng: position.longitude,
        qrCode: qrCode,
      );

      if (success) {
        // Update UI or fetch shifts again
        fetchShifts();
      }
    } catch (e) {
      log('handleCheckIn Error: $e');
      toast('Error checking in');
    } finally {
      isCheckingIn(false);
    }
  }

  Future<void> handleCheckOut(ShiftModel shift, {String? qrCode}) async {
    if (isCheckingOut.value) return;
    
    isCheckingOut(true);
    try {
      final position = await getCurrentLocation();
      if (position == null) {
        toast('Could not get current location');
        return;
      }

      final success = await ShiftServiceApis.checkOut(
        attendanceId: currentAttendanceId.value,
        userId: loginUserData.value.idString,
        shiftId: shift.id,
        checkOutLat: position.latitude,
        checkOutLng: position.longitude,
        qrCode: qrCode,
      );

      if (success) {
        // Update UI or fetch shifts again
        fetchShifts();
      }
    } catch (e) {
      log('handleCheckOut Error: $e');
      toast('Error checking out');
    } finally {
      isCheckingOut(false);
    }
  }

  void showCheckInOutDialog(ShiftModel shift, bool isCheckIn) {
    final qrCode = ''.obs;
    final isScanning = false.obs;
    final isLoading = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isCheckIn ? 'Check In' : 'Check Out',
                      style: boldTextStyle(size: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift Details',
                        style: boldTextStyle(size: 16),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.access_time,
                        label: 'Time',
                        value: DateFormat('hh:mm a').format(
                          isCheckIn ? shift.timeTable.checkInTime : shift.timeTable.checkOutTime,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        label: 'Branch',
                        value: shift.branch.name,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => isScanning.value
                    ? Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QRScannerWidget(
                              onScan: (code) {
                                qrCode.value = code;
                                isScanning.value = false;
                                Get.back();
                                if (isCheckIn) {
                                  handleCheckIn(shift, qrCode: qrCode.value);
                                } else {
                                  handleCheckOut(shift, qrCode: qrCode.value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              isScanning.value = false;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Cancel Scan'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Obx(() => ElevatedButton.icon(
                                onPressed: isLoading.value
                                    ? null
                                    : () async {
                                        isLoading(true);
                                        final position = await getCurrentLocation();
                                        if (position != null) {
                                          Get.back();
                                          if (isCheckIn) {
                                            await handleCheckIn(shift);
                                          } else {
                                            await handleCheckOut(shift);
                                          }
                                        }
                                        isLoading(false);
                                      },
                                icon: isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.my_location,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                label: Text(
                                  isLoading.value
                                      ? 'Getting Location...'
                                      : 'Use Current Location',
                                  textAlign: TextAlign.center,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appColorPrimary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                              )),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              isScanning.value = true;
                            },
                            icon: const Icon(
                              Icons.qr_code,
                              size: 24,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Scan QR Code',
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColorPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: appColorPrimary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: secondaryTextStyle(size: 14),
        ),
        Text(
          value,
          style: boldTextStyle(size: 14),
        ),
      ],
    );
  }

  Widget _buildShiftCard(BuildContext context, ShiftModel shift) {
    final isDark = isDarkMode.value;
    final timeTable = shift.timeTable;
    final color = Color(int.parse(timeTable.color.replaceAll('#', '0xFF')));
    final controller = Get.find<ShiftsController>();

    // Check attendance status
    final hasAttendance = shift.attendance.isNotEmpty;
    final currentAttendance = hasAttendance ? shift.attendance.last : null;
    final canCheckIn = !hasAttendance || currentAttendance?.checkOutDate != null;
    final canCheckOut = hasAttendance && currentAttendance?.checkOutDate == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? appBodyColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... existing header code ...
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... existing shift info rows ...
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (canCheckIn)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            controller.showCheckInOutDialog(shift, true);
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(locale.value.checkIn),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (canCheckIn && canCheckOut) const SizedBox(width: 12),
                    if (canCheckOut)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.showCheckInOutDialog(shift, false);
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: Text(locale.value.checkout),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
