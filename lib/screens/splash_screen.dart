import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/app_scaffold.dart';
import '../components/loader_widget.dart';
import '../generated/assets.dart';
import '../utils/colors.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController = Get.put(SplashScreenController());
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      scaffoldBackgroundColor: context.cardColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              Assets.assetsAppLogo,
              height: 150,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            height: Get.height * 0.3,
            bottom: 0,
            child: const LoaderWidget(isBlurBackground: false, loaderColor: appColorPrimary),
          ),
        ],
      ),
    );
  }
}
