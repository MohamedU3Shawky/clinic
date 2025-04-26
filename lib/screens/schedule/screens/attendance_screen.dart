import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:egphysio_clinic_admin/models/attendance.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../controllers/attendance_controller.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.put(AttendanceController());

    return AppScaffoldNew(
      appBartitleText: locale.value.attendance,
      appBarVerticalSize: Get.height * 0.12,
      body: Column(
        children: [
          // Week selector
          _buildWeekSelector(controller),
          16.height,
          // Attendance list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.attendanceList.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchAttendance(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.attendanceList.length,
                  itemBuilder: (context, index) {
                    final employee = controller.attendanceList[index];
                    return _buildEmployeeCard(employee, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector(AttendanceController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode.value ? scaffoldDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous week button
          _buildWeekNavButton(
            icon: Icons.chevron_left,
            onPressed: () {
              final newDate = controller.selectedDate.value.subtract(
                const Duration(days: 7),
              );
              controller.setSelectedDate(newDate);
            },
          ),

          // Week display
          Obx(() {
            final startOfWeek = controller.selectedDate.value.subtract(
              Duration(days: controller.selectedDate.value.weekday - 1),
            );
            final endOfWeek = startOfWeek.add(const Duration(days: 6));

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode.value
                    ? appColorPrimary.withOpacity(0.2)
                    : appColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: isDarkMode.value ? Colors.white : appColorPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(endOfWeek)}',
                    style: boldTextStyle(
                      size: 16,
                      color: isDarkMode.value ? Colors.white : appColorPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Next week button
          _buildWeekNavButton(
            icon: Icons.chevron_right,
            onPressed: () {
              final newDate = controller.selectedDate.value.add(
                const Duration(days: 7),
              );
              controller.setSelectedDate(newDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode.value
            ? Colors.grey.withOpacity(0.2)
            : appColorPrimary.withOpacity(0.1),
        boxShadow: [
          if (!isDarkMode.value)
            BoxShadow(
              color: appColorPrimary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 24,
          color: isDarkMode.value ? Colors.white : appColorPrimary,
        ),
        onPressed: onPressed,
        splashRadius: 24,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(
      EmployeeAttendance employee, AttendanceController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode.value ? cardDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDarkMode.value)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode.value
                  ? Colors.grey.withOpacity(0.1)
                  : appColorPrimary.withOpacity(0.05),
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
                    color: isDarkMode.value
                        ? Colors.grey.withOpacity(0.2)
                        : appColorPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: isDarkMode.value ? Colors.white : appColorPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.user.name,
                        style: boldTextStyle(
                          size: 16,
                          color: isDarkMode.value
                              ? Colors.white
                              : textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.user.email,
                        style: secondaryTextStyle(
                          size: 14,
                          color: isDarkMode.value
                              ? Colors.grey[400]
                              : textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Attendance details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...employee.days.map((day) => _buildDayRow(day, controller)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(DayAttendance day, AttendanceController controller) {
    final statusColor = controller.getStatusColor(day.status);
    final statusIcon = controller.getStatusIcon(day.status);
    final statusDescription = controller.getStatusDescription(day.status);

    return GestureDetector(
      onTap: () {
        // Only show dialog if there's a shift and it's not a holiday
        if (day.shift != null && day.holiday == null) {
          _showShiftDetailsDialog(day, controller);
        } else if (day.attendance != null && day.attendance!.isNotEmpty) {
          _showAttendanceDetailsDialog(day, controller);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode.value
              ? Colors.grey.withOpacity(0.05)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode.value
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.formatDate(day.date),
                        style: boldTextStyle(
                          size: 14,
                          color: isDarkMode.value
                              ? Colors.white
                              : textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day.status,
                        style: secondaryTextStyle(
                          size: 12,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (day.workedMinutes != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode.value
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(day.workedMinutes! / 60).floor()}h ${day.workedMinutes! % 60}m',
                      style: secondaryTextStyle(
                        size: 12,
                        color:
                            isDarkMode.value ? Colors.white : textPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              statusDescription,
              style: secondaryTextStyle(
                size: 12,
                color: isDarkMode.value ? Colors.grey[400] : textSecondaryColor,
              ),
            ),
            if (day.holiday != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Holiday: ${day.holiday!.name}',
                      style: boldTextStyle(
                        size: 12,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reason: ${day.holiday!.reason}',
                      style: secondaryTextStyle(
                        size: 12,
                        color: isDarkMode.value
                            ? Colors.grey[400]
                            : textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (day.shift != null &&
                day.status.toLowerCase() != "no shift" &&
                day.holiday == null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${day.shift!.name} (${controller.formatTime(day.shift!.currentDay?.startDate ?? day.shift!.startDate)} - ${controller.formatTime(day.shift!.currentDay?.endDate ?? day.shift!.endDate)})',
                      style: secondaryTextStyle(
                        size: 12,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (day.attendance != null && day.attendance!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${day.attendance!.length} attendance record${day.attendance!.length > 1 ? 's' : ''}',
                      style: secondaryTextStyle(
                        size: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showShiftDetailsDialog(
      DayAttendance day, AttendanceController controller) {
    final shift = day.shift!;
    final currentDay = shift.currentDay;

    Get.dialog(
      Dialog(
        backgroundColor: isDarkMode.value ? cardDarkColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shift Details',
                    style: boldTextStyle(
                      size: 18,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Shift Name',
                shift.name,
                Icons.business_center,
              ),
              _buildDetailRow(
                'Schedule',
                '${controller.formatDate(shift.startDate)} - ${controller.formatDate(shift.endDate)}',
                Icons.calendar_today,
              ),
              if (currentDay != null) ...[
                _buildDetailRow(
                  'Shift Time',
                  '${controller.formatTime(currentDay.startDate)} - ${controller.formatTime(currentDay.endDate)}',
                  Icons.access_time,
                ),
                _buildDetailRow(
                  'Punch Window',
                  '${controller.formatTime(currentDay.punchFrom)} - ${controller.formatTime(currentDay.punchTo)}',
                  Icons.timer,
                ),
                if (currentDay.breakStartTime != null &&
                    currentDay.breakEndTime != null)
                  _buildDetailRow(
                    'Break Time',
                    '${controller.formatTime(currentDay.breakStartTime!)} - ${controller.formatTime(currentDay.breakEndTime!)}',
                    Icons.coffee,
                  ),
                _buildDetailRow(
                  'Late In Allowed',
                  currentDay.allowLateIn
                      ? 'Yes (${currentDay.lateInThreshold} mins)'
                      : 'No',
                  Icons.warning,
                ),
                _buildDetailRow(
                  'Early Out Allowed',
                  currentDay.allowEarlyOut
                      ? 'Yes (${currentDay.earlyOutThreshold} mins)'
                      : 'No',
                  Icons.timer_off,
                ),
                _buildDetailRow(
                  'Overtime Enabled',
                  currentDay.enableOT ? 'Yes' : 'No',
                  Icons.timer_3,
                ),
                if (currentDay.enableOT) ...[
                  _buildDetailRow(
                    'Early In OT Threshold',
                    '${currentDay.earlyInOTThreshold} mins',
                    Icons.timer_3,
                  ),
                  _buildDetailRow(
                    'Late Out OT Threshold',
                    '${currentDay.lateOutOTThreshold} mins',
                    Icons.timer_3,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAttendanceDetailsDialog(
      DayAttendance day, AttendanceController controller) {
    if (day.attendance == null || day.attendance!.isEmpty) return;

    Get.dialog(
      Dialog(
        backgroundColor: isDarkMode.value ? cardDarkColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance Details',
                    style: boldTextStyle(
                      size: 18,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...day.attendance!.map((record) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Check In',
                        record.checkInDate != null
                            ? controller.formatTime(record.checkInDate!)
                            : 'Not checked in',
                        Icons.login,
                      ),
                      if (record.checkInLat != null &&
                          record.checkInLng != null)
                        _buildDetailRow(
                          'Check In Location',
                          '${record.checkInLat}, ${record.checkInLng}',
                          Icons.location_on,
                        ),
                      _buildDetailRow(
                        'Check Out',
                        record.checkOutDate != null
                            ? controller.formatTime(record.checkOutDate!)
                            : 'Not checked out',
                        Icons.logout,
                      ),
                      if (record.checkOutLat != null &&
                          record.checkOutLng != null)
                        _buildDetailRow(
                          'Check Out Location',
                          '${record.checkOutLat}, ${record.checkOutLng}',
                          Icons.location_on,
                        ),
                      _buildDetailRow(
                        'Type',
                        record.automatic == true ? 'Automatic' : 'Manual',
                        Icons.timer,
                      ),
                      const Divider(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode.value ? Colors.white : appColorPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: secondaryTextStyle(
                    size: 12,
                    color: isDarkMode.value
                        ? Colors.grey[400]
                        : textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: boldTextStyle(
                    size: 14,
                    color: isDarkMode.value ? Colors.white : textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appColorPrimary.withOpacity(0.2),
                    appColorPrimary.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy,
                size: 80,
                color: appColorPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              locale.value.noAttendanceFound,
              style: boldTextStyle(
                size: 18,
                color: isDarkMode.value ? Colors.white : textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locale.value.noAttendanceFoundDesc,
              style: secondaryTextStyle(
                size: 14,
                color: isDarkMode.value ? Colors.grey[400] : textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
