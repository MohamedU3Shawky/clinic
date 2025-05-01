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
        color: isDarkMode.value ? cardBackgroundBlackDark : white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
          width: 1.5,
        ),
        boxShadow: isDarkMode.value
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
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
                      ? Colors.grey.withOpacity(0.1)
                      : appColorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedImageWidget(
                  url: Assets.iconsIcClock,
                  height: 24,
                  width: 24,
                  color: appColorPrimary,
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
                        color:
                            isDarkMode.value ? Colors.white : textPrimaryColor,
                      ),
                    ),
                    4.height,
                    Text(
                      schedule.description ?? '',
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
              IconButton(
                icon: CachedImageWidget(
                  url: Assets.iconsIcEdit,
                  height: 20,
                  width: 20,
                  color: appColorPrimary,
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
                  ? Colors.grey.withOpacity(0.1)
                  : appColorPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                _buildInfoItem(
                  icon: Assets.iconsIcTimeOutlined,
                  text:
                      '${schedule.startTime ?? ''} - ${schedule.endTime ?? ''}',
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
          color: appColorPrimary,
        ),
        8.width,
        Text(
          text,
          style: secondaryTextStyle(
            size: 12,
            color: isDarkMode.value ? Colors.grey[400] : textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
