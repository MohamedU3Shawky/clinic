import 'dart:convert';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/clinic/model/clinics_res_model.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import '../utils/shared_preferences.dart';

class UserDataService {
  static Future<void> saveUserData({
    required UserData userData,
    required String password,
    required bool rememberUser,
    String? apiToken,
  }) async {
    try {
      // Convert UserData to JSON and validate it can be parsed back
      final userDataJson = userData.toJson();
      UserData.fromJson(userDataJson); // Validation test
      print("USER_DATA222: ${userDataJson}");

      await CashHelper.saveData(
          key: SharedPreferenceConst.USER_DATA, value: userDataJson);
      await CashHelper.saveData(
          key: SharedPreferenceConst.USER_ID, value: userData.idString);

      if (apiToken != null && apiToken.isNotEmpty) {
        await CashHelper.saveData(
            key: SharedPreferenceConst.API_TOKEN, value: apiToken);
      }

      await CashHelper.saveData(
          key: SharedPreferenceConst.USER_PASSWORD, value: password);
      await CashHelper.saveData(
          key: SharedPreferenceConst.IS_LOGGED_IN, value: true);
      await CashHelper.saveData(
          key: SharedPreferenceConst.REMEMBER_USER, value: rememberUser);

      log('User data saved successfully');
    } catch (e) {
      log('Error saving user data: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  static Future<void> saveClinicData(ClinicData clinicData) async {
    try {
      final clinicJson = clinicData.toJson();
      ClinicData.fromJson(clinicJson); // Validation test

      await CashHelper.saveData(
          key: SharedPreferenceConst.CLINIC_DATA, value: clinicJson);
      await CashHelper.saveData(
          key: SharedPreferenceConst.CLINIC_ID, value: clinicData.id);

      log('Clinic data saved successfully');
    } catch (e) {
      log('Error saving clinic data: $e');
      throw Exception('Failed to save clinic data: $e');
    }
  }

  static Future<UserData?> getUserData() async {
    try {
      final userData = CashHelper.getData(key: SharedPreferenceConst.USER_DATA);
      if (userData == null) return null;

      return UserData.fromJson(userData);
    } catch (e) {
      log('Error retrieving user data: $e');
      return null;
    }
  }

  static Future<ClinicData?> getClinicData() async {
    try {
      final clinicData =
          CashHelper.getData(key: SharedPreferenceConst.CLINIC_DATA);
      if (clinicData == null) return null;

      return ClinicData.fromJson(clinicData);
    } catch (e) {
      log('Error retrieving clinic data: $e');
      return null;
    }
  }

  static Future<bool> isUserLoggedIn() async {
    return CashHelper.getData(key: SharedPreferenceConst.IS_LOGGED_IN) ?? false;
  }

  static Future<bool> shouldRememberUser() async {
    return CashHelper.getData(key: SharedPreferenceConst.REMEMBER_USER) ??
        false;
  }

  static Future<String?> getApiToken() async {
    return CashHelper.getData(key: SharedPreferenceConst.API_TOKEN);
  }

  static Future<void> clearUserData() async {
    try {
      await CashHelper.removeData(key: SharedPreferenceConst.USER_DATA);
      await CashHelper.removeData(key: SharedPreferenceConst.USER_ID);
      await CashHelper.removeData(key: SharedPreferenceConst.API_TOKEN);
      await CashHelper.removeData(key: SharedPreferenceConst.USER_PASSWORD);
      await CashHelper.removeData(key: SharedPreferenceConst.IS_LOGGED_IN);
      await CashHelper.removeData(key: SharedPreferenceConst.CLINIC_DATA);
      await CashHelper.removeData(key: SharedPreferenceConst.CLINIC_ID);
      // Don't clear REMEMBER_USER preference as it's a user setting

      log('User data cleared successfully');
    } catch (e) {
      log('Error clearing user data: $e');
      throw Exception('Failed to clear user data: $e');
    }
  }
}
