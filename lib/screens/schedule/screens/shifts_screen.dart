import 'package:egphysio_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:table_calendar/table_calendar.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../models/shift_model.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/api_end_points.dart';
import '../../../network/network_utils.dart';
import '../../../controllers/shifts_controller.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShiftsController controller = Get.put(ShiftsController());

    return AppScaffoldNew(
      hasLeadingWidget: false,
      appBartitleText: locale.value.shifts,
      appBarVerticalSize: Get.height * 0.12,
      hideAppBar: false,
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      //     onPressed: () {
      //       // TODO: Navigate to add shift screen
      //     },
      //   ),
      // ],
      body: Column(
        children: [
          _buildViewToggle(controller),
          Obx(() => _buildDateSelector(controller)),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () async {
                  if (controller.viewMode.value == 'daily') {
                    await controller.fetchShifts();
                  } else {
                    await controller.fetchShifts();
                  }
                },
                child: controller.shifts.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: Get.height * 0.4,
                          alignment: Alignment.center,
                          child: nb.NoDataWidget(
                            title: locale.value.noShiftsFound,
                            imageWidget: const EmptyStateWidget(),
                            subTitle: locale.value.noShiftsAvailable,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 80 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: _buildShiftsList(context, controller),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(ShiftsController controller) {
    return Obx(() => Container(
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: isDarkMode.value ? appBodyColor : nb.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: dividerColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.toggleViewMode();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.viewMode.value == 'daily'
                          ? appColorPrimary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          color: controller.viewMode.value == 'daily'
                              ? Colors.white
                              : appColorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.toggleViewMode();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.viewMode.value == 'weekly'
                          ? appColorPrimary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          color: controller.viewMode.value == 'weekly'
                              ? Colors.white
                              : appColorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDateSelector(ShiftsController controller) {
    if (controller.viewMode.value == 'daily') {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: TableCalendar(
          rowHeight: Get.height * 0.045,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: controller.selectedDate.value,
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDate.value, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            controller.setSelectedDate(selectedDay);
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: appColorPrimary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: appColorPrimary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
      );
    } else {
      // Weekly view date selector
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                final newStartDate = controller.weekStartDate.value
                    .subtract(const Duration(days: 7));
                final newEndDate = controller.weekEndDate.value
                    .subtract(const Duration(days: 7));
                controller.setWeekDates(newStartDate, newEndDate);
              },
            ),
            Text(
              '${DateFormat('MMM d').format(controller.weekStartDate.value)} - ${DateFormat('MMM d, yyyy').format(controller.weekEndDate.value)}',
              style: nb.boldTextStyle(size: 16),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                final newStartDate =
                    controller.weekStartDate.value.add(const Duration(days: 7));
                final newEndDate =
                    controller.weekEndDate.value.add(const Duration(days: 7));
                controller.setWeekDates(newStartDate, newEndDate);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _buildShiftsList(BuildContext context, ShiftsController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0, // Add padding for bottom navbar
      ),
      itemCount: controller.shifts.length,
      itemBuilder: (context, index) {
        final shift = controller.shifts[index];
        return _buildShiftCard(context, shift);
      },
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
    final canCheckIn =
        !hasAttendance || currentAttendance?.checkOutDate != null;
    final canCheckOut =
        hasAttendance && currentAttendance?.checkOutDate == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? cardBackgroundBlackDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.withOpacity(0.1)
                  : color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.withOpacity(0.2)
                        : color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CachedImageWidget(
                    url: Assets.iconsIcClock,
                    height: 24,
                    width: 24,
                    color: isDark ? Colors.white : color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeTable.name,
                        style: nb.boldTextStyle(
                          size: 16,
                          color: isDark ? Colors.white : primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shift.branch.name,
                        style: nb.secondaryTextStyle(
                          size: 14,
                          color: isDark ? Colors.grey[400] : secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShiftInfoRow(
                  icon: Icons.person,
                  label: locale.value.employee,
                  value: shift.user.name,
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.access_time,
                  label: locale.value.checkIn,
                  value: DateFormat('hh:mm a').format(timeTable.checkInTime),
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.access_time,
                  label: locale.value.checkout,
                  value: DateFormat('hh:mm a').format(timeTable.checkOutTime),
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.calendar_today,
                  label: locale.value.recurrence,
                  value: shift.recurrenceRule,
                ),
                if (shift.weekDays.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildShiftInfoRow(
                    icon: Icons.date_range,
                    label: locale.value.days,
                    value: shift.weekDays.join(', '),
                  ),
                ],
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.date_range,
                  label: locale.value.period,
                  value:
                      '${DateFormat('MMM d').format(shift.startDate)} - ${DateFormat('MMM d, yyyy').format(shift.endDate ?? shift.startDate)}',
                ),
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
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showPermissionDialog(context, shift),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(locale.value.applyPermission),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode.value ? Colors.white : appColorPrimary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: nb.secondaryTextStyle(
            size: 14,
            color: isDarkMode.value ? Colors.grey[400] : secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: nb.boldTextStyle(
            size: 14,
            color: isDarkMode.value ? Colors.white : primaryTextColor,
          ),
        ),
      ],
    );
  }

  void _showPermissionDialog(BuildContext context, ShiftModel shift) {
    final permissionType = 'LateIn'.obs;
    final hours = 0.obs;
    final minutes = 0.obs;
    final reasonController = TextEditingController();

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
                  Text(
                    'Apply Permission',
                    style: nb.boldTextStyle(size: 20),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => DropdownButtonFormField<String>(
                        value: permissionType.value,
                        decoration: InputDecoration(
                          labelText: 'Permission Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'LateIn',
                            child: Text('Late In'),
                          ),
                          DropdownMenuItem(
                            value: 'EarlyLeave',
                            child: Text('Early Leave'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            permissionType.value = value;
                          }
                        },
                      )),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => DropdownButtonFormField<int>(
                              value: hours.value,
                              decoration: InputDecoration(
                                labelText: 'Hours',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: List.generate(
                                24,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text('$index hours'),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  hours.value = value;
                                }
                              },
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => DropdownButtonFormField<int>(
                              value: minutes.value,
                              decoration: InputDecoration(
                                labelText: 'Minutes',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: List.generate(
                                60,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(
                                    '$index minutes',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  minutes.value = value;
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final totalMinutes =
                                (hours.value * 60) + minutes.value;
                            if (totalMinutes == 0) {
                              nb.toast('Please select a duration');
                              return;
                            }

                            try {
                              final response = await buildHttpResponse(
                                APIEndPoints.attendancePermissions,
                                request: {
                                  'shiftId': shift.id,
                                  'type': permissionType.value,
                                  'duration': hours.value,
                                  if (reasonController.text.trim().isNotEmpty)
                                    'reason': reasonController.text.trim(),
                                },
                                method: nb.HttpMethodType.POST,
                              );

                              final data = await handleResponse(response);

                              if (data['success'] == true) {
                                nb.toast('Permission applied successfully');
                                Get.back();
                              } else {
                                nb.toast(data['message'] ??
                                    'Failed to apply permission');
                              }
                            } catch (e) {
                              nb.toast('Error applying permission: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
