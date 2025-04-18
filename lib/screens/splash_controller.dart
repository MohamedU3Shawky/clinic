// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../api/auth_apis.dart';
import '../api/home_apis.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';

import '../utils/shared_preferences.dart';
import 'auth/model/change_password_res.dart';
import 'auth/model/clinic_center_argument_model.dart';
import 'auth/model/login_response.dart';
import 'auth/sign_in_sign_up/signin_screen.dart';
import 'clinic/model/clinics_res_model.dart';
import 'dashboard/dashboard_screen.dart';
import 'home/choose_clinic_screen.dart';
import 'home/home_controller.dart';
import '../services/user_data_service.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void init() {
    Future.delayed(const Duration(seconds: 5), () => getAppConfigurations());
  }
}

RxBool isLoading = false.obs;

///Get ChooseService List
getAppConfigurations() async {
  try {
    ///Navigation logic
    final isRememberUser = await UserDataService.shouldRememberUser();
    log("REMEMBER_USER value: $isRememberUser");

    if (!isRememberUser) {
      Get.offAll(() => SignInScreen());
      return;
    }

    // User wants to be remembered, check if we have user data
    final userData = await UserDataService.getUserData();
    print("USER_DATA: ${userData?.toJson()}");
    if (userData == null) {
      log("User data not found, redirecting to login");
      Get.offAll(() => SignInScreen());
      return;
    }

    try {
      isLoggedIn(true);
      loginUserData(userData);

      // Check for clinic data
      final clinicData = await UserDataService.getClinicData();
      log("CLINIC_DATA: $clinicData");

      if (clinicData != null) {
        selectedAppClinic(clinicData);
      } else {
        selectedAppClinic(ClinicData()); // Default empty clinic
      }

      // Check if clinic ID is selected
      final clinicId = clinicData?.id;

      // Navigate directly to dashboard
      navigateToDashboard();

      // if (clinicId == null) {
      //   // Navigate to clinic selection
      //   Get.to(
      //     () => ChooseClinicScreen(),
      //     arguments: ClinicCenterArgumentModel(
      //       selectedClinc: selectedAppClinic.value,
      //     ),
      //   )?.then((value) {
      //     if (value is ClinicData) {
      //       selectedAppClinic(value);
      //       UserDataService.saveClinicData(value).then((_) {
      //         navigateToDashboard();
      //       }).catchError((e) {
      //         log("Error saving clinic data: $e");
      //         toast("Error saving clinic data", print: true);
      //       });
      //     }
      //   });
      // } else {
      //   // Navigate directly to dashboard
      //   navigateToDashboard();
      // }
    } catch (e) {
      log("Error processing user data: $e");
      Get.offAll(() => SignInScreen());
    }
  } catch (e) {
    log("Error in getAppConfigurations: $e");
    Get.offAll(() => SignInScreen());
  }
}

void navigateToDashboard() {
  Get.offAll(
    () => DashboardScreen(),
    binding: BindingsBuilder(() {
      // Get.put(HomeController());
    }),
  );
}
