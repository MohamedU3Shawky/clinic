import 'package:get/get.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import 'forget_pass_controller.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);
  final ForgetPasswordController forgetPassController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: forgetPassController.isLoading,
      hasLeadingWidget: true,
      clipBehaviorSplitRegion: Clip.none,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top gradient section with logo
            Container(
              height: Get.height * 0.35,
              width: Get.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    appColorPrimary,
                    appColorSecondary.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: appColorPrimary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.assetsAppLogo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    16.height,
                    Text(
                      locale.value.forgotPassword,
                      style: boldTextStyle(color: whiteTextColor, size: 22),
                    ),
                  ],
                ),
              ),
            ),
            
            // Forgot Password Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: appColorPrimary.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: forgetPassController.forgotPassFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.value.resetYourPassword,
                      style: boldTextStyle(size: 20, color: appColorPrimary),
                    ),
                    8.height,
                    Text(
                      locale.value.enterYourEmailAddressToResetYourNewPassword,
                      style: secondaryTextStyle(size: 14),
                    ),
                    24.height,
                    CachedImageWidget(
                      url: Assets.imagesForgotPassBg,
                      height: Get.height * 0.2,
                      width: Get.width,
                      fit: BoxFit.contain,
                    ),
                    24.height,
                    
                    // Email field
                    Text(locale.value.email, style: boldTextStyle(size: 14, color: appColorSecondary)),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 14),
                      controller: forgetPassController.emailCont,
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      decoration: InputDecoration(
                        hintText: 'example@domain.com',
                        hintStyle: secondaryTextStyle(size: 14),
                        fillColor: appColorPrimary.withOpacity(0.05),
                        filled: true,
                        prefixIcon: Icon(Icons.email_outlined, color: appColorPrimary, size: 20),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: appColorPrimary, width: 1),
                        ),
                      ),
                    ),
                    40.height,
                    
                    // Send Code button
                    Container(
                      width: Get.width,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [appColorPrimary, appColorSecondary],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: appColorPrimary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            hideKeyboard(context);
                            if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                              forgetPassController.forgotPassFormKey.currentState!.save();
                              forgetPassController.saveForm();
                            }
                          },
                          child: Center(
                            child: Text(
                              locale.value.sendCode,
                              style: boldTextStyle(color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Back to login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(locale.value.alreadyHaveAnAccount, style: secondaryTextStyle()),
                8.width,
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    locale.value.signIn,
                    style: boldTextStyle(
                      size: 14,
                      color: appColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            32.height,
          ],
        ),
      ),
    );
  }
}
