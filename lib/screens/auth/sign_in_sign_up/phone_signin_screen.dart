import 'package:egphysio_clinic_admin/configs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../generated/assets.dart';

class PhoneSignInScreen extends StatefulWidget {
  PhoneSignInScreen({Key? key}) : super(key: key);

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final TextEditingController phoneController = TextEditingController();
  final RxString selectedCountryCode = '+20'.obs; // Default to Egypt

  final List<Map<String, String>> countries = [
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: true,
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

            // Phone input card
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your phone number',
                    style: boldTextStyle(size: 24, color: appColorPrimary),
                  ),
                  8.height,
                  Text(
                    'We will send you a verification code',
                    style: secondaryTextStyle(size: 14),
                  ),
                  30.height,

                  // Country code dropdown and phone number input
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(() => DropdownButton<String>(
                              value: selectedCountryCode.value,
                              underline: SizedBox(),
                              items: countries.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country['code'],
                                  child: Row(
                                    children: [
                                      Text(country['flag']!),
                                      8.width,
                                      Text(country['code']!),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedCountryCode.value = value;
                                }
                              },
                            )),
                      ),
                      12.width,
                      Expanded(
                        child: AppTextField(
                          textStyle: primaryTextStyle(size: 14),
                          controller: phoneController,
                          textFieldType: TextFieldType.PHONE,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: secondaryTextStyle(size: 14),
                            fillColor: appColorPrimary.withOpacity(0.05),
                            filled: true,
                            prefixIcon: Icon(Icons.phone_outlined,
                                color: appColorPrimary, size: 20),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
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
                      ),
                    ],
                  ),
                  30.height,

                  // Continue button
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
                          // TODO: Implement phone verification logic
                          hideKeyboard(context);
                        },
                        child: Center(
                          child: Text(
                            'Continue',
                            style: boldTextStyle(color: Colors.white, size: 16),
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
                          child:
                              Divider(color: appColorPrimary.withOpacity(0.2))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: secondaryTextStyle(color: appColorSecondary),
                        ),
                      ),
                      Expanded(
                          child:
                              Divider(color: appColorPrimary.withOpacity(0.2))),
                    ],
                  ),

                  10.height,
                  // Continue with email button
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
                          Get.back();
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email_outlined,
                                  color: appColorPrimary, size: 20),
                              8.width,
                              Text(
                                'Continue with Email',
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
          ],
        ),
      ),
    );
  }
}
