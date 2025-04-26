import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../components/cached_image_widget.dart';
import '../model/schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback onEdit;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: isDarkMode.value ? 0.5 : 1,
        ),
        boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value 
                    ? appColorPrimary.withOpacity(0.15)
                    : appColorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedImageWidget(
                  url: Assets.iconsIcClock,
                  height: 24,
                  width: 24,
                  color: isDarkMode.value ? Colors.white : appColorPrimary,
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.title ?? '',
                      style: boldTextStyle(
                        size: 16,
                        color: isDarkMode.value ? Colors.white : textPrimaryColor,
                      ),
                    ),
                    4.height,
                    Text(
                      schedule.description ?? '',
                      style: secondaryTextStyle(
                        size: 14,
                        color: isDarkMode.value ? Colors.white.withOpacity(0.8) : textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: CachedImageWidget(
                  url: Assets.iconsIcEdit,
                  height: 20,
                  width: 20,
                  color: isDarkMode.value ? Colors.white.withOpacity(0.8) : appColorPrimary,
                ),
                onPressed: onEdit,
              ),
            ],
          ).paddingAll(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: boxDecorationDefault(
              color: isDarkMode.value
                  ? Colors.grey.withOpacity(0.08)
                  : appColorPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildInfoItem(
                  icon: Assets.iconsIcTimeOutlined,
                  text: '${schedule.startTime ?? ''} - ${schedule.endTime ?? ''}',
                ),
                16.width,
                _buildInfoItem(
                  icon: Assets.iconsIcCalendar,
                  text: schedule.days.join(', '),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required String icon, required String text}) {
    return Row(
      children: [
        CachedImageWidget(
          url: icon,
          height: 16,
          width: 16,
          color: isDarkMode.value ? Colors.white.withOpacity(0.7) : appColorPrimary,
        ),
        8.width,
        Text(
          text,
          style: secondaryTextStyle(
            size: 12,
            color: isDarkMode.value ? Colors.white.withOpacity(0.7) : textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
