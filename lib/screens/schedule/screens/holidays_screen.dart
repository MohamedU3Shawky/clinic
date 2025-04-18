import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/controllers/holidays_controller.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/models/holiday_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HolidaysController controller = Get.put(HolidaysController());
    controller.fetchHolidaysForMonth();

    return AppScaffoldNew(
      appBartitleText: locale.value.holidays,
      appBarVerticalSize: Get.height * 0.12,
      body: Column(
        children: [
          // Month selector
          _buildMonthSelector(controller),

          // Only this part will rebuild when the month changes
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                );
              }

              return _buildHolidayList(controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(HolidaysController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Previous month button
          _buildMonthNavButton(
            icon: Icons.chevron_left,
            onPressed: () {
              final newDate = DateTime(
                controller.selectedMonth.value.year,
                controller.selectedMonth.value.month - 1,
                1,
              );
              controller.setMonth(newDate);
            },
            isDark: isDarkMode.value,
          ),

          // Month/year display
          Container(
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
                Obx(() => Text(
                      DateFormat('MMMM yyyy')
                          .format(controller.selectedMonth.value),
                      style: boldTextStyle(
                        size: 16,
                        color:
                            isDarkMode.value ? Colors.white : appColorPrimary,
                      ),
                    )),
              ],
            ),
          ),

          // Next month button
          _buildMonthNavButton(
            icon: Icons.chevron_right,
            onPressed: () {
              final newDate = DateTime(
                controller.selectedMonth.value.year,
                controller.selectedMonth.value.month + 1,
                1,
              );
              controller.setMonth(newDate);
            },
            isDark: isDarkMode.value,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.grey.withOpacity(0.2)
            : appColorPrimary.withOpacity(0.1),
        boxShadow: [
          if (!isDark)
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
          color: isDark ? Colors.white : appColorPrimary,
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

  Widget _buildHolidayList(HolidaysController controller) {
    final userHolidays = controller.getUserHolidays();

    if (userHolidays.isEmpty) {
      return _buildEmptyState(controller);
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchHolidaysForMonth(),
      backgroundColor: isDarkMode.value ? scaffoldDarkColor : Colors.white,
      color: appColorPrimary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: userHolidays.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final holiday = userHolidays[index];
          return _buildModernHolidayCard(context, holiday);
        },
      ),
    );
  }

  Widget _buildModernHolidayCard(BuildContext context, HolidayModel holiday) {
    final isDark = isDarkMode.value;
    final now = DateTime.now();
    final isInPast =
        holiday.from.isBefore(DateTime(now.year, now.month, now.day));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? cardDarkColor : Colors.white,
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
          // Header with status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: scheduleHolidaysColor.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheduleHolidaysColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event,
                    color: scheduleHolidaysColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),

                // Holiday name and date range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        holiday.name,
                        style: boldTextStyle(
                          size: 16,
                          color: isDark ? Colors.white : textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${DateFormat.yMMMd().format(holiday.from)} → ${DateFormat.yMMMd().format(holiday.to)}",
                        style: secondaryTextStyle(
                          size: 14,
                          color: scheduleHolidaysColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Holiday details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason
                _buildModernDetailRow(
                  icon: Icons.note_outlined,
                  label: locale.value.reason,
                  value: holiday.reason,
                  isDark: isDark,
                  isMultiline: true,
                ),

                const SizedBox(height: 12),

                // Users
                _buildModernDetailRow(
                  icon: Icons.people_outline,
                  label: locale.value.users,
                  value: holiday.users.map((u) => u.name).join(', '),
                  isDark: isDark,
                  isMultiline: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: appColorPrimary.withOpacity(isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: appColorPrimary,
          ),
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
                  color: isDark ? Colors.grey[400] : textSecondaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: boldTextStyle(
                  size: 14,
                  color: isDark ? Colors.white : textPrimaryColor,
                ),
                maxLines: isMultiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(HolidaysController controller) {
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

            // Title with subtle animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                locale.value.noHolidaysFound,
                style: boldTextStyle(
                  size: 18,
                  color: isDarkMode.value ? Colors.white : textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              locale.value.noHolidaysDescription,
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
