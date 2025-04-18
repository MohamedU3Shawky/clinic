import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../models/shift_model.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import 'shifts_controller.dart';

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
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          onPressed: () {
            // TODO: Navigate to add shift screen
          },
        ),
      ],
      body: Column(
        children: [
          _buildViewToggle(controller),
          Obx(() => _buildDateSelector(controller)),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildShiftsList(controller);
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
            color: isDarkMode.value ? appBodyColor : white,
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
              style: boldTextStyle(size: 16),
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

  Widget _buildShiftsList(ShiftsController controller) {
    if (controller.shifts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No shifts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
        bottom: 100, // Add padding for bottom navbar
      ),
      itemCount: controller.shifts.length,
      itemBuilder: (context, index) {
        final shift = controller.shifts[index];
        return _buildShiftCard(shift);
      },
    );
  }

  Widget _buildShiftCard(ShiftModel shift) {
    final isDark = isDarkMode.value;
    final timeTable = shift.timeTable;
    final color = Color(int.parse(timeTable.color.replaceAll('#', '0xFF')));

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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CachedImageWidget(
                    url: Assets.iconsIcClock,
                    height: 24,
                    width: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeTable.name,
                        style: boldTextStyle(size: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shift.branch.name,
                        style: secondaryTextStyle(size: 14),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? appDarkBodyColor : secondaryTextColor,
                  ),
                  onSelected: (value) {
                    // TODO: Implement shift actions
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
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
                  label: 'Employee',
                  value: shift.user.name,
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.access_time,
                  label: 'Check In',
                  value: DateFormat('hh:mm a').format(timeTable.checkInTime),
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.access_time,
                  label: 'Check Out',
                  value: DateFormat('hh:mm a').format(timeTable.checkOutTime),
                ),
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Recurrence',
                  value: shift.recurrenceRule,
                ),
                if (shift.weekDays.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildShiftInfoRow(
                    icon: Icons.date_range,
                    label: 'Days',
                    value: shift.weekDays.join(', '),
                  ),
                ],
                const SizedBox(height: 8),
                _buildShiftInfoRow(
                  icon: Icons.date_range,
                  label: 'Period',
                  value:
                      '${DateFormat('MMM d').format(shift.startDate)} - ${DateFormat('MMM d, yyyy').format(shift.endDate ?? shift.startDate)}',
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {},
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {},
                        icon: const Icon(Icons.cancel_outlined),
                        label: Text(locale.value.applyPermission),
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
}
