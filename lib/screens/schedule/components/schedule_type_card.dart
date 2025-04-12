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
          color: isDarkMode.value ? appBodyColor : white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: boxDecorationDefault(
                color: color.withOpacity(0.1),
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
              style: boldTextStyle(size: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 