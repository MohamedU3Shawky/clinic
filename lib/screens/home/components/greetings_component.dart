import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../auth/other/notification_screen.dart';

class GreetingsComponent extends StatelessWidget {
  const GreetingsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👋 ${locale.value.welcomeBack}', style: appButtonTextStyleWhite),
              4.height,
              Obx(
                () => Text(
                  '${locale.value.hey}, ${loginUserData.value.firstName.isNotEmpty ? loginUserData.value.firstName.capitalizeEachWord().validate() : (loginUserData.value.userName.isNotEmpty ? loginUserData.value.userName.split(' ').first.capitalizeEachWord() : locale.value.guest.validate())}',
                  style: primaryTextStyle(color: white, size: 20),
                ),
              )
            ],
          ).expand(),
          16.width,
          GestureDetector(
            onTap: () {
              Get.to(() => NotificationScreen());
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const CachedImageWidget(
                  url: Assets.navigationIcNotifyOutlined,
                  color: Colors.white,
                  height: 24,
                ),
                Positioned(
                  top: -8 + -(2 * unreadNotificationCount.value.toString().length).toDouble(),
                  right: -4 + -(2 * unreadNotificationCount.value.toString().length).toDouble(),
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: boxDecorationDefault(color: appColorSecondary, shape: BoxShape.circle),
                      child: Text(
                        unreadNotificationCount.value.toString(),
                        style: secondaryTextStyle(color: white, size: 10),
                      ),
                    ).visible(unreadNotificationCount.value > 0),
                  ),
                )
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 24),
    );
  }
}
