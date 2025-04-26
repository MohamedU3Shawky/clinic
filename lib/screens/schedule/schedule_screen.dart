import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/schedule/screens/attendance_screen.dart';
import 'package:kivicare_clinic_admin/screens/schedule/screens/overtime_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../generated/assets.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import 'schedule_controller.dart';
import 'components/schedule_type_card.dart';
import 'screens/leaves_screen.dart';
import 'screens/holidays_screen.dart';
import 'screens/attendance_permissions_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScheduleController controller = Get.put(ScheduleController());

    return AppScaffoldNew(
      hasLeadingWidget: false,
      appBartitleText: locale.value.schedule,
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.height,
              _buildScheduleTypes(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScheduleTypes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            ScheduleTypeCard(
              title: locale.value.leaves,
              icon: Assets.iconsIcCalendar,
              color: Colors.blue,
              onTap: () => Get.to(() => LeavesScreen()),
            ),
            ScheduleTypeCard(
              title: locale.value.holidays,
              icon: Assets.iconsIcCalendarplus,
              color: Colors.green,
              onTap: () => Get.to(() => HolidaysScreen()),
            ),
            ScheduleTypeCard(
              title: locale.value.attendance,
              icon: Assets.iconsIcClock,
              color: Colors.orange,
              onTap: () => Get.to(() => const AttendanceScreen()),
            ),
            ScheduleTypeCard(
              title: 'Attendance Permissions',
              icon: Assets.iconsIcRequest,
              color: Colors.purple,
              onTap: () => Get.to(() => const AttendancePermissionsScreen()),
            ),
             ScheduleTypeCard(
              title: locale.value.overtime,
              icon: Assets.iconsIcTimeOutlined,
              color: Colors.purple,
              onTap: () => Get.to(() => OvertimeScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSchedules(
      BuildContext context, ScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.value.recentAppointment,
              style: boldTextStyle(size: 18),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all schedules
              },
              child: Text(
                locale.value.viewAll,
                style: boldTextStyle(color: appColorPrimary),
              ),
            ),
          ],
        ),
        16.height,
        if (controller.schedules.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "no schedules found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 32)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.schedules.length > 3
                ? 3
                : controller.schedules.length,
            itemBuilder: (context, index) {
              final schedule = controller.schedules[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? cardDarkColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode.value ? dividerDarkColor : dividerColor),
                  boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: boxDecorationDefault(
                      color: appColorPrimary.withOpacity(isDarkMode.value ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedImageWidget(
                      url: Assets.iconsIcClock,
                      height: 24,
                      width: 24,
                      color: isDarkMode.value ? Colors.white70 : appColorPrimary,
                    ),
                  ),
                  title: Text(
                    schedule.title,
                    style: boldTextStyle(
                      size: 16,
                      color: isDarkMode.value ? Colors.white : textPrimaryColor,
                    ),
                  ),
                  subtitle: Text(
                    '${schedule.startTime.toString().substring(0, 10)} - ${schedule.endTime.toString().substring(0, 10)}',
                    style: secondaryTextStyle(
                      size: 14,
                      color: isDarkMode.value ? Colors.white70 : textSecondaryColor,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationDefault(
                      color: _getStatusColor(schedule.status).withOpacity(isDarkMode.value ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      schedule.status,
                      style: boldTextStyle(
                        size: 12,
                        color: _getStatusColor(schedule.status),
                      ),
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to schedule detail
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
