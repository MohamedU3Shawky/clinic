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
    Future.delayed(const Duration(seconds: 5),()=> getAppConfigurations());
  }
}
RxBool isLoading = false.obs;

///Get ChooseService List
getAppConfigurations() {
  try {
    ///Navigation logic
    bool? isRememberUser = CashHelper.getData(key: SharedPreferenceConst.REMEMBER_USER);
    log("REMEMBER_USER value: $isRememberUser");
    
    if (isRememberUser == null || isRememberUser == false) {
      Get.offAll(() => SignInScreen());
      return;
    }
    
    // User wants to be remembered, check if we have user data
    final userData = CashHelper.getData(key: SharedPreferenceConst.USER_DATA);
    if (userData == null) {
      log("User data not found, redirecting to login");
      Get.offAll(() => SignInScreen());
      return;
    }
    
    try {
      isLoggedIn(true);
      loginUserData.value = UserData.fromJson(userData);
      
      // Check for clinic data
      var clinicData = CashHelper.getData(key: SharedPreferenceConst.CLINIC_DATA);
      log("CLINIC_DATA: $clinicData");
      
      if (clinicData != null) {
        selectedAppClinic(ClinicData.fromJson(clinicData));
      } else {
        selectedAppClinic(ClinicData()); // Default empty clinic
      }
      
      // Check if clinic ID is selected
      var clinicId = CashHelper.getData(key: SharedPreferenceConst.CLINIC_ID);
      if (clinicId == null) {
        // Navigate to clinic selection
        Get.to(
          () => ChooseClinicScreen(),
          arguments: ClinicCenterArgumentModel(
            selectedClinc: selectedAppClinic.value,
          ),
        )?.then((value) {
          if (value is ClinicData) {
            selectedAppClinic(value);
            CashHelper.saveData(key: SharedPreferenceConst.CLINIC_DATA, value: value);
            navigateToDashboard();
          }
        });
      } else {
        // Navigate directly to dashboard
        navigateToDashboard();
      }
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
      Get.put(HomeController());
    }),
  );
}