// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/shared_preferences.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../home/choose_clinic_screen.dart';
import '../../home/home_controller.dart';
import '../model/clinic_center_argument_model.dart';
import '../model/login_response.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../model/login_roles_model.dart';
import '../../clinic/model/clinics_res_model.dart';

class SignInController extends GetxController {
  RxBool isNavigateToDashboard = false.obs;
  final GlobalKey<FormState> signInformKey = GlobalKey();

  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxString userName = "".obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  Rx<LoginRoleData> selectedLoginRole = LoginRoleData().obs;

  void toggleSwitch() {
    isRememberMe.value = !isRememberMe.value;
  }

  @override
  void onInit() {
 /*   if (Get.arguments is bool) {
      log(Get.arguments);
      log("isNavigateToDashboard before:$isNavigateToDashboard");
      isNavigateToDashboard(Get.arguments == true);
      log("isNavigateToDashboard after:$isNavigateToDashboard");
    }*/
   /* final userIsRemeberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    final userNameFromLocal = getValueFromLocal(SharedPreferenceConst.USER_NAME);
    if (userNameFromLocal is String) {
      userName(userNameFromLocal);
    }
    if (userIsRemeberMe == true) {
      final userEmail = getValueFromLocal(SharedPreferenceConst.USER_EMAIL);
      if (userEmail is String) {
        emailCont.text = userEmail;
      }
      final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      if (userPASSWORD is String) {
        passwordCont.text = userPASSWORD;
      }
    }*/
    super.onInit();
  }

  Future<void> saveForm() async {
    hideKeyBoardWithoutContext();
    if (emailCont.text.trim().isEmpty || passwordCont.text.trim().isEmpty) {
      toast("Please enter valid email and password");
      return;
    }
    
    isLoading(true);
    Map<String, dynamic> req = {
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
    };
    
    await AuthServiceApis.loginUser(request: req).then((value) async {
      handleLoginResponse(loginResponse: value);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleLoginResponse({required UserResponse loginResponse}) {
    try {
      log("test:isRememberMe.value##${isRememberMe.value}");
      
      // Map the API response to our UserData model
      UserData userData = loginResponse.userData;
      
      // Store the API token for future requests
      String apiToken = userData.apiToken;
      log("API Token received: $apiToken");
      
      // If the token is empty, check if it's in the raw data
      if (apiToken.isEmpty && loginResponse.data != null) {
        // Check if token is directly in the data
        if (loginResponse.data!.containsKey('token')) {
          apiToken = loginResponse.data!['token'].toString();
          userData.apiToken = apiToken;
          log("API Token found in raw data: $apiToken");
        }
        // Check if token is inside a 'user' object
        else if (loginResponse.data!.containsKey('user') && 
                loginResponse.data!['user'] is Map && 
                (loginResponse.data!['user'] as Map).containsKey('token')) {
          apiToken = loginResponse.data!['user']['token'].toString();
          userData.apiToken = apiToken;
          log("API Token found in user object: $apiToken");
        }
      }
      
      // If the userData object has empty or invalid values, we need to map from the API structure
      if (userData.firstName.isEmpty && apiToken.isNotEmpty) {
        // The API response contains data in a different format than our model expects
        try {
          // Map the user's name (in this case, the 'name' from API would go to firstName)
          if (userData.userName.isNotEmpty) {
            List<String> nameParts = userData.userName.split(' ');
            if (nameParts.isNotEmpty) userData.firstName = nameParts[0];
            if (nameParts.length > 1) userData.lastName = nameParts.sublist(1).join(' ');
          }
          
          // If we have raw data, try to extract more information
          if (loginResponse.data != null) {
            Map<String, dynamic> rawData = loginResponse.data!;
            
            // Extract user data from different structures
            Map<String, dynamic>? userMap;
            if (rawData.containsKey('user') && rawData['user'] is Map) {
              userMap = Map<String, dynamic>.from(rawData['user']);
            }
            
            if (userMap != null) {
              // Update fields that might be missing
              if (userData.email.isEmpty && userMap.containsKey('email')) {
                userData.email = userMap['email'].toString();
              }
              if (userData.userName.isEmpty && userMap.containsKey('name')) {
                userData.userName = userMap['name'].toString();
                
                // Also update first/last name
                List<String> nameParts = userData.userName.split(' ');
                if (nameParts.isNotEmpty) userData.firstName = nameParts[0];
                if (nameParts.length > 1) userData.lastName = nameParts.sublist(1).join(' ');
              }
              if (userMap.containsKey('id') && userData.id < 0) {
                userData.id = userMap['id'] is int ? userMap['id'] : int.tryParse(userMap['id'].toString()) ?? -1;
              }
            }
          }
        } catch (e) {
          log("Error mapping user data: $e");
        }
      }
      
      // Save the user data
      loginUserData(userData);
      
      // Make sure the token is not empty before saving
      if (apiToken.isEmpty) {
        log("Warning: API token is empty. Authentication may fail for future requests.");
      } else {
        log("Saving API token to preferences: $apiToken");
      }
      
      // Save essential user data to shared preferences
      CashHelper.saveData(key: SharedPreferenceConst.USER_ID, value: userData.id);
      CashHelper.saveData(key: SharedPreferenceConst.API_TOKEN, value: apiToken);
      
      // We need to use toJson to properly serialize the object
      CashHelper.saveData(key: SharedPreferenceConst.USER_DATA, value: userData.toJson());
      CashHelper.saveData(key: SharedPreferenceConst.USER_PASSWORD, value: passwordCont.text.trim());
      
      // Update login status
      isLoggedIn(true);
      CashHelper.saveData(key: SharedPreferenceConst.IS_LOGGED_IN, value: true);
      CashHelper.saveData(key: SharedPreferenceConst.REMEMBER_USER, value: isRememberMe.value);

      isLoading(false);

      // Handle navigation
      Get.to(
        () => ChooseClinicScreen(),
        arguments: ClinicCenterArgumentModel(
          selectedClinc: selectedAppClinic.value,
        ),
      )?.then((value) {
        if (value is ClinicData) {
          selectedAppClinic(value);
          log("Clinic selected: ${value.name}, ID: ${value.id}");
          
          // Save the clinic data properly using toJson
          CashHelper.saveData(key: SharedPreferenceConst.CLINIC_DATA, value: value.toJson());
          CashHelper.saveData(key: SharedPreferenceConst.CLINIC_ID, value: value.id);
          
          // Navigate to dashboard
          Get.offAll(() => DashboardScreen(),
            binding: BindingsBuilder(() {
              Get.put(HomeController());
            }));
        }
      });
    } catch (e) {
      log("Error in handleLoginResponse: $e");
      isLoading(false);
      toast("Login failed: ${e.toString()}", print: true);
    }
  }
}
