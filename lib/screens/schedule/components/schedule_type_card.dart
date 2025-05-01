import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class ScheduleTypeCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const ScheduleTypeCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: boxDecorationDefault(
          color: isDarkMode.value ? cardBackgroundBlackDark : white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isDarkMode.value ? Colors.grey.withOpacity(0.2) : dividerColor,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: boxDecorationDefault(
                color: isDarkMode.value
                    ? Colors.grey.withOpacity(0.1)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedImageWidget(
                url: icon,
                height: 32,
                width: 32,
                color: color,
              ),
            ),
            12.height,
            Text(
              title,
              style: boldTextStyle(
                size: 15,
                color: isDarkMode.value ? Colors.white : textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
