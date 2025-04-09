import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../configs.dart';
import '../generated/assets.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.appLogoSize,
      width: Constants.appLogoSize,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        width: 100, // Set your desired width
        height: 100, // Set your desired height
        child: Image.asset(
          Assets.assetsAppLogo,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => Text(
            APP_NAME.toUpperCase(),
            style: boldTextStyle(
              color: appColorPrimary,
              letterSpacing: 10,
            ),
          ),
        ),
      ),
    );
  }
}
