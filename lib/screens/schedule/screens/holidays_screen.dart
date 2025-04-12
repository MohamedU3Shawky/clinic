import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../model/schedule_model.dart';

class HolidaysScreen extends StatelessWidget {
  HolidaysScreen({Key? key}) : super(key: key);

  final RxList<ScheduleModel> holidays = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: "holidays",
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Navigate to add holiday screen
          },
          icon: const Icon(Icons.add_circle_outline_rounded,
              size: 28, color: Colors.white),
        ).paddingOnly(right: 8),
      ],
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "holidays",
                style: boldTextStyle(size: 24),
              ),
              8.height,
              Text(
                locale.value.manageSessions,
                style: secondaryTextStyle(size: 16),
              ),
              24.height,
              _buildHolidayCalendar(),
              24.height,
              _buildHolidaysList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHolidayCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? appBodyColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Holidays',
            style: boldTextStyle(size: 18),
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCalendarItem(
                date: '25',
                month: 'Dec',
                title: 'Christmas',
                isToday: true,
              ),
              _buildCalendarItem(
                date: '01',
                month: 'Jan',
                title: 'New Year',
                isToday: false,
              ),
              _buildCalendarItem(
                date: '15',
                month: 'Jan',
                title: 'Martin Luther King Jr. Day',
                isToday: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarItem({
    required String date,
    required String month,
    required String title,
    required bool isToday,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: boxDecorationDefault(
        color: isToday
            ? Colors.red.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            month,
            style: secondaryTextStyle(size: 14),
          ),
          4.height,
          Text(
            date,
            style: boldTextStyle(size: 24, color: isToday ? Colors.red : null),
          ),
          4.height,
          Text(
            title,
            style: secondaryTextStyle(size: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaysList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Holidays',
          style: boldTextStyle(size: 18),
        ),
        16.height,
        if (holidays.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No holidays found',
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
            itemCount: holidays.length,
            itemBuilder: (context, index) {
              final holiday = holidays[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? appBodyColor : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: dividerColor),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: boxDecorationDefault(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedImageWidget(
                      url: Assets.iconsIcCalendar,
                      height: 24,
                      width: 24,
                      color: Colors.red,
                    ),
                  ),
                  title: Text(
                    holiday.title,
                    style: boldTextStyle(size: 16),
                  ),
                  subtitle: Text(
                    holiday.startTime.toString().substring(0, 10),
                    style: secondaryTextStyle(size: 14),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationDefault(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Holiday',
                      style: boldTextStyle(size: 12, color: Colors.red),
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to holiday detail
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
