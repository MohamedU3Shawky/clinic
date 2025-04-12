import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../models/shift_model.dart';
import '../../../api/shift_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchShifts();
    fetchMonthShifts();
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
}
