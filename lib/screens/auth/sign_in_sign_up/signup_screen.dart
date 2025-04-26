import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:egphysio_clinic_admin/components/app_logo_widget.dart';
import 'package:egphysio_clinic_admin/utils/constants.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../configs.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../doctor/clinic_center/clinic_center_screen.dart';
import '../model/clinic_center_argument_model.dart';
import 'sign_up_controller.dart';
import '../model/login_roles_model.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: signUpController.isLoading,
      hasLeadingWidget: false,
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
                    appColorSecondary,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: appColorPrimary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
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
                      APP_NAME,
                      style: boldTextStyle(color: whiteTextColor, size: 22),
                    ),
                  ],
                ),
              ),
            ),
            
            // Signup form card with improved styling
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: appColorPrimary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: signUpController.signUpformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title with consistent styling
                    Text(
                      locale.value.signUp,
                      style: boldTextStyle(size: 24, color: appColorPrimary),
                    ),
                    8.height,
                    Text(
                      locale.value.createYourAccount,
                      style: secondaryTextStyle(size: 14),
                    ),
                    30.height,

                    // First name - fixed parameters
                    Text(locale.value.firstName, style: primaryTextStyle(size: 14, color: textSecondaryColor)),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 14),
                      controller: signUpController.fisrtNameCont,
                      focus: signUpController.fisrtNameFocus,
                      nextFocus: signUpController.lastNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(
                        hintText: locale.value.firstName,
                        hintStyle: secondaryTextStyle(size: 14),
                        fillColor: appColorPrimary.withOpacity(0.05),
                        filled: true,
                        prefixIcon: Icon(Icons.person_outline, color: appColorPrimary, size: 20),
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
                    16.height,

                    // Last name field
                    Text(locale.value.lastName, style: primaryTextStyle(size: 14, color: textSecondaryColor)),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 14),
                      controller: signUpController.lastNameCont,
                      focus: signUpController.lastNameFocus,
                      nextFocus: signUpController.emailFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(
                        hintText: locale.value.lastName,
                        hintStyle: secondaryTextStyle(size: 14),
                        fillColor: appColorPrimary.withOpacity(0.05),
                        filled: true,
                        prefixIcon: Icon(Icons.person_outline, color: appColorPrimary, size: 20),
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
                    16.height,
                    
                    // Email field
                    Text(locale.value.email, style: primaryTextStyle(size: 14, color: textSecondaryColor)),
                    8.height,
                    Obx(
                      () => AppTextField(
                        textStyle: primaryTextStyle(size: 14),
                        controller: signUpController.emailCont,
                        focus: signUpController.emailFocus,
                        nextFocus: signUpController.passwordFocus,
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
                          errorText: signUpController.emailError.value.isNotEmpty
                              ? signUpController.emailError.value
                              : null,
                        ),
                      ),
                    ),
                    16.height,

                    // User Type field with gradient style
                    Text(locale.value.selectUserRole, style: primaryTextStyle(size: 14, color: textSecondaryColor)),
                    8.height,
                    Obx(
                      () => AppTextField(
                        textStyle: primaryTextStyle(size: 14),
                        controller: signUpController.userTypeCont,
                        focus: signUpController.userTypeFocus,
                        textFieldType: TextFieldType.NAME,
                        readOnly: true,
                        onTap: () async {
                          chooseEmployeeType(
                            context,
                            isLoading: signUpController.isLoading,
                            onChange: (p0) {
                              signUpController.selectedLoginRole(p0);
                              signUpController.userTypeCont.text = p0.roleName;
                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: locale.value.selectUserRole,
                          hintStyle: secondaryTextStyle(size: 14),
                          fillColor: appColorPrimary.withOpacity(0.05),
                          filled: true,
                          prefixIcon: signUpController.selectedLoginRole.value.icon.isEmpty && signUpController.selectedLoginRole.value.id.isNegative
                              ? Icon(Icons.work_outline, color: appColorPrimary, size: 20)
                              : CachedImageWidget(url: signUpController.selectedLoginRole.value.icon, color: appColorPrimary, height: 22, fit: BoxFit.cover, width: 22)
                                  .paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: appColorPrimary),
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
                    ),
                    16.height,
                    
                    // Terms and conditions with improved styling
                    Obx(
                      () => CheckboxListTile(
                        checkColor: whiteColor,
                        value: signUpController.isAcceptedTc.value,
                        activeColor: appColorPrimary,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) async {
                          signUpController.isAcceptedTc.value = !signUpController.isAcceptedTc.value;
                        },
                        checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                        side: BorderSide(color: appColorPrimary.withOpacity(0.5)),
                        title: RichTextWidget(
                          list: [
                            TextSpan(text: "${locale.value.iAgreeToThe} ", style: secondaryTextStyle()),
                            TextSpan(
                              text: locale.value.termsConditions,
                              style: primaryTextStyle(color: appColorPrimary, size: 12, decoration: TextDecoration.underline, decorationColor: appColorPrimary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication);
                                },
                            ),
                            TextSpan(text: " ${locale.value.and} ", style: secondaryTextStyle()),
                            TextSpan(
                              text: locale.value.privacyPolicy,
                              style: primaryTextStyle(color: appColorPrimary, size: 12, decoration: TextDecoration.underline, decorationColor: appColorPrimary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    30.height,
                    
                    // Sign Up button with matching gradient style from signin screen
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
                            color: appColorPrimary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            hideKeyboard(context);
                            if (signUpController.signUpformKey.currentState!.validate()) {
                              signUpController.signUpformKey.currentState!.save();
                              signUpController.saveForm();
                            }
                          },
                          child: Center(
                            child: Text(
                              locale.value.signUp,
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
            
            // Already have an account with improved styling
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
                      decoration: TextDecoration.underline,
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
