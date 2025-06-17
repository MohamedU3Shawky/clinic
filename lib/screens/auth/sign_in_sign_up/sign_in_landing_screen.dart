import 'package:egphysio_clinic_admin/configs.dart';
import 'package:egphysio_clinic_admin/screens/auth/services/biometric_service.dart';
import 'package:egphysio_clinic_admin/screens/auth/sign_in_sign_up/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../generated/assets.dart';
import 'signin_screen.dart';
import 'phone_signin_screen.dart';

class SignInLandingScreen extends StatefulWidget {
  const SignInLandingScreen({Key? key}) : super(key: key);

  @override
  State<SignInLandingScreen> createState() => _SignInLandingScreenState();
}

class _SignInLandingScreenState extends State<SignInLandingScreen> {
  RxBool isBiometricAvailable = false.obs;
  RxBool isBiometricEnabled = false.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    checkBiometricAvailability();
    super.initState();
  }

  Future<void> checkBiometricAvailability() async {
    isBiometricAvailable.value = await BiometricService.isBiometricsAvailable();
    if (isBiometricAvailable.value) {
      final credentials = await BiometricService.getCredentials();
      print('credentials: $credentials');
      isBiometricEnabled.value = credentials != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());
    return AppScaffoldNew(
      hasLeadingWidget: false,
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

            // Sign in options card
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
                    'Welcome Back',
                    style: boldTextStyle(size: 24, color: brandColorSecondary),
                  ),
                  8.height,
                  Text(
                    'Choose your sign in method',
                    style: secondaryTextStyle(size: 14),
                  ),
                  30.height,

                  // Email Sign In Button
                  _buildSignInButton(
                    icon: Icons.email_outlined,
                    title: 'Sign in with Email',
                    onTap: () => Get.to(() => SignInScreen()),
                  ),
                  16.height,

                  // Phone Sign In Button
                  _buildSignInButton(
                    icon: Icons.phone_outlined,
                    title: 'Sign in with Phone',
                    onTap: () => Get.to(() => PhoneSignInScreen()),
                  ),
                  16.height,

                  // Biometric Sign In Button
                  Obx(() {
                    if (isBiometricAvailable.value) {
                      return _buildSignInButton(
                        icon: isLoading.value
                            ? Icons.hourglass_empty
                            : Icons.fingerprint,
                        title: isLoading.value
                            ? 'Authenticating...'
                            : (isBiometricEnabled.value
                                ? 'Sign in with Biometrics'
                                : 'Set up Biometric Login'),
                        onTap: () async {
                          if (isBiometricEnabled.value) {
                            isLoading.value = true;
                            try {
                              await signInController
                                  .authenticateWithBiometric();
                            } finally {
                              isLoading.value = false;
                            }
                          } else {
                            // Show dialog to choose between email and phone setup
                            Get.dialog(
                              AlertDialog(
                                title: Text('Choose Setup Method'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Please choose how you want to set up biometric login',
                                      style: secondaryTextStyle(size: 14),
                                    ),
                                    20.height,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Get.back(); // Close dialog
                                              Get.to(() => SignInScreen(),
                                                  arguments: {
                                                    'fromBiometricSetup': true
                                                  });
                                            },
                                            icon: Icon(
                                              Icons.email_outlined,
                                              color: whiteTextColor,
                                            ),
                                            label: Text('Use Email'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appColorPrimary,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                            ),
                                          ),
                                        ),
                                        16.width,
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Get.back(); // Close dialog
                                              Get.to(() => PhoneSignInScreen(),
                                                  arguments: {
                                                    'fromBiometricSetup': true
                                                  });
                                            },
                                            icon: Icon(
                                              Icons.phone_outlined,
                                              color: whiteTextColor,
                                            ),
                                            label: Text('Use Phone'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appColorPrimary,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
        color: appColorPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brandColorSecondary.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: brandColorSecondary, size: 20),
                8.width,
                Text(
                  title,
                  style: primaryTextStyle(
                    size: 16,
                    color: brandColorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
