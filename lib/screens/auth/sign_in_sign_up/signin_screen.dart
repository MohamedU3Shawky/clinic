import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import '../../../components/app_logo_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../configs.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/login_roles_model.dart';
import 'sign_in_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../password/forget_password_screen.dart';
import 'signup_screen.dart';
import 'phone_signin_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: signInController.isLoading,
      hasLeadingWidget: false,
      clipBehaviorSplitRegion: Clip.none,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top gradient section with logo
            Container(
              height: Get.height * 0.33,
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
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      APP_NAME,
                      style: boldTextStyle(color: whiteTextColor, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // Login form card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 24),
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
                key: signInController.signInformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.value.welcomeBack,
                      style: boldTextStyle(size: 24, color: appColorPrimary),
                    ),
                    8.height,
                    Text(
                      '${locale.value.welcomeBackToThe} $APP_NAME',
                      style: secondaryTextStyle(size: 14),
                    ),
                    15.height,

                    // Email field
                    Text(locale.value.email,
                        style:
                            boldTextStyle(size: 14, color: appColorSecondary)),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 14),
                      controller: signInController.emailCont,
                      focus: signInController.emailFocus,
                      nextFocus: signInController.passwordFocus,
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      decoration: InputDecoration(
                        hintText: 'example@domain.com',
                        hintStyle: secondaryTextStyle(size: 14),
                        fillColor: appColorPrimary.withOpacity(0.05),
                        filled: true,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: appColorPrimary, size: 20),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                          borderSide:
                              BorderSide(color: appColorPrimary, width: 1),
                        ),
                      ),
                    ),
                    15.height,

                    // Password field
                    Text(locale.value.password,
                        style:
                            boldTextStyle(size: 14, color: appColorSecondary)),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 14),
                      controller: signInController.passwordCont,
                      focus: signInController.passwordFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: secondaryTextStyle(size: 14),
                        fillColor: appColorPrimary.withOpacity(0.05),
                        filled: true,
                        prefixIcon: Icon(Icons.lock_outline,
                            color: appColorPrimary, size: 20),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                          borderSide:
                              BorderSide(color: appColorPrimary, width: 1),
                        ),
                      ),
                    ),
                    16.height,

                    // Remember me and Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: signInController.isRememberMe.value,
                                activeColor: appColorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: radius(4)),
                                side: BorderSide(
                                    color: appColorPrimary.withOpacity(0.5)),
                                onChanged: (val) {
                                  signInController.toggleSwitch();
                                },
                              ),
                            ),
                            Text(
                              locale.value.rememberMe,
                              style:
                                  secondaryTextStyle(color: appColorSecondary),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ForgetPassword(),
                                transition: Transition.rightToLeft);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            locale.value.forgotPassword,
                            style: primaryTextStyle(
                              size: 14,
                              color: appColorPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.height,

                    // Login button
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
                            if (signInController.signInformKey.currentState!
                                .validate()) {
                              signInController.signInformKey.currentState!
                                  .save();
                              signInController.saveForm();
                            }
                          },
                          child: Center(
                            child: Text(
                              locale.value.signIn,
                              style:
                                  boldTextStyle(color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ),
                    ),

                    10.height,

                    // Divider with "or" text
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: appColorPrimary.withOpacity(0.2))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: secondaryTextStyle(color: appColorSecondary),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                                color: appColorPrimary.withOpacity(0.2))),
                      ],
                    ),

                    10.height,
                    // Continue with phone button
                    Container(
                      width: Get.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: appColorPrimary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: appColorPrimary.withOpacity(0.2)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Get.to(() => PhoneSignInScreen(),
                                transition: Transition.rightToLeft);
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone_outlined,
                                    color: appColorPrimary, size: 20),
                                8.width,
                                Text(
                                  'Continue with Phone',
                                  style: primaryTextStyle(
                                    size: 16,
                                    color: appColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Demo accounts button
            if (isIqonicProduct)
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  chooseEmployeeType(
                    context,
                    isLoading: signInController.isLoading,
                    onChange: (p0) {
                      signInController.emailCont.text = p0.email;
                      signInController.passwordCont.text = p0.password;
                      hideKeyboard(context);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    locale.value.demoAccounts,
                    style: primaryTextStyle(
                      size: 14,
                      color: appColorPrimary,
                    ),
                  ),
                ),
              ),
            32.height,
          ],
        ),
      ),
    );
  }
}

void chooseEmployeeType(BuildContext context,
    {RxBool? isLoading,
    required Function(LoginRoleData) onChange,
    bool isFromDemoAccountTap = false}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Demo Account',
            style: boldTextStyle(size: 18, color: appColorPrimary),
          ),
          16.height,
          ListView.separated(
            itemCount: loginRoles.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: appColorPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SettingItemWidget(
                  title: loginRoles[index].roleName,
                  titleTextStyle: primaryTextStyle(size: 14),
                  leading: CachedImageWidget(
                      url: loginRoles[index].icon,
                      color: appColorPrimary,
                      height: 22,
                      fit: BoxFit.fitHeight,
                      width: 22),
                  onTap: () {
                    onChange(loginRoles[index]);
                    Get.back();
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => 12.height,
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
  );
}
