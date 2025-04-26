import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:egphysio_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:egphysio_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/change_password_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/auth/model/notification_model.dart';

class AuthServiceApis {
  static Future<UserResponse> createUser({required Map request}) async {
    return UserResponse.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.register,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<UserResponse> loginUser(
      {required Map request, bool isSocialLogin = false}) async {
    var response = await handleResponse(await buildHttpResponse(
        isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login,
        request: request,
        method: HttpMethodType.POST));
    log('Login response: ${jsonEncode(response)}');

    // Create a UserResponse object with the raw data
    UserResponse userResponse;

    // If the API structure is different than our model expects
    if (response['status'] is int ||
        (response['data'] is Map && response['data']['user'] is Map)) {
      // Extract the token from the response
      String token = "";
      if (response['data'] is Map && response['data']['token'] != null) {
        token = response['data']['token'].toString();
      } else if (response['data'] is Map &&
          response['data']['user'] is Map &&
          response['data']['user']['token'] != null) {
        token = response['data']['user']['token'].toString();
      }

      // Extract user information
      Map<String, dynamic> userData = {};
      if (response['data'] is Map && response['data']['user'] is Map) {
        userData = Map<String, dynamic>.from(response['data']['user']);
      } else if (response['data'] is Map) {
        userData = Map<String, dynamic>.from(response['data']);
      }

      // Create a structure that our UserResponse class can parse
      var transformedResponse = {
        'status': response['status'] == 200 ||
            response['status'] == true, // Convert HTTP status to boolean
        'message': response['message'] ?? 'Login successful',
        'data': {
          // Create 'data' with expected properties for UserData.fromJson
          'id': userData['id'] ?? -1,
          'first_name': userData['name']?.toString().split(' ').first ??
              userData['first_name'] ??
              '',
          'last_name': (userData['name']?.toString().split(' ').length ?? 0) > 1
              ? userData['name'].toString().split(' ').sublist(1).join(' ')
              : userData['last_name'] ?? '',
          'user_name': userData['name'] ?? userData['user_name'] ?? '',
          'email': userData['email'] ?? '',
          'mobile': userData['phone'] ?? userData['mobile'] ?? '',
          'gender': userData['gender'] ?? '',
          'profile_image':
              userData['avatar'] ?? userData['profile_image'] ?? '',
          'api_token': token,
          'user_type': userData['user_type'] ?? '',
          // Add other fields as needed
        }
      };
      userResponse = UserResponse.fromJson(transformedResponse);
      print("userResponse: ${userResponse.userData.idString}");

      // Store the raw data for additional processing if needed
      userResponse.data = response['data'] is Map
          ? Map<String, dynamic>.from(response['data'])
          : null;
    } else {
      // Standard parsing for the normal response structure
      userResponse = UserResponse.fromJson(response);
    }

    // Ensure we have the token
    if (userResponse.userData.apiToken.isEmpty) {
      log('Warning: API token not found in response. Authentication may fail.');
    } else {
      log('API token successfully extracted: ${userResponse.userData.apiToken.substring(0, min(10, userResponse.userData.apiToken.length))}...');
    }

    return userResponse;
  }

  static Future<ChangePassRes> changePasswordAPI({required Map request}) async {
    return ChangePassRes.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.changePassword,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordAPI(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.forgotPassword,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final notificationRes = NotificationRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getNotification}?per_page=$perPage&page=$page",
              method: HttpMethodType.GET)));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack
          ?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.clearAllNotification,
            method: HttpMethodType.GET)));
  }

  static Future<NotificationData> removeNotification(
      {required String notificationId}) async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.removeNotification}?id=$notificationId',
            method: HttpMethodType.GET)));
  }

  static Future<void> clearData({bool isFromDeleteAcc = false}) async {
    GoogleSignIn().signOut();
    // PushNotificationService().unsubscribeFirebaseTopic();
    if (isFromDeleteAcc) {
      localStorage.erase();
      isLoggedIn(false);
      loginUserData(UserData());
    } else {
      final tempEmail = loginUserData.value.email;
      final tempPASSWORD =
          getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      final tempIsRemeberMe =
          getValueFromLocal(SharedPreferenceConst.REMEMBER_USER);
      final tempUserName = loginUserData.value.userName;

      localStorage.erase();
      isLoggedIn(false);
      loginUserData(UserData());
      selectedAppClinic(ClinicData());

      setValueToLocal(SharedPreferenceConst.FIRST_TIME, true);
      setValueToLocal(SharedPreferenceConst.USER_EMAIL, tempEmail);
      setValueToLocal(SharedPreferenceConst.USER_NAME, tempUserName);

      if (tempPASSWORD is String) {
        setValueToLocal(SharedPreferenceConst.USER_PASSWORD, tempPASSWORD);
      }
      if (tempIsRemeberMe is bool) {
        setValueToLocal(SharedPreferenceConst.REMEMBER_USER, tempIsRemeberMe);
      }
    }
  }

  static Future<BaseResponseModel> logoutApi() async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.logout,
            method: HttpMethodType.GET)));
  }

  static Future<BaseResponseModel> deleteAccountCompletely() async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.deleteUserAccount,
            request: {}, method: HttpMethodType.POST)));
  }

  // static Future<ConfigurationResponse> getAppConfigurations() async {
  //   return ConfigurationResponse.fromJson(await handleResponse(
  //       await buildHttpResponse(
  //           '${APIEndPoints.appConfiguration}?is_authenticated=${(getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true).getIntBool()}',
  //           request: {},
  //           method: HttpMethodType.GET)));
  // }

  static Future<UserResponse> viewProfile({int? id}) async {
    var res = UserResponse.fromJson(await handleResponse(
        await buildHttpResponse('${APIEndPoints.userDetail}',
            method: HttpMethodType.GET)));
    return res;
  }

  static Future<dynamic> updateProfile({
    File? imageFile,
    String firstName = '',
    String lastName = '',
    String email = '',
    String mobile = '',
    String address = '',
    String gender = '',
    String playerId = '',
    String dateOfBirth = '',
    String country = '',
    String state = '',
    String city = '',
    String pinCode = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest =
          await getMultiPartRequest(APIEndPoints.updateProfile);
      if (firstName.isNotEmpty)
        multiPartRequest.fields[UserKeys.firstName] = firstName;
      if (lastName.isNotEmpty)
        multiPartRequest.fields[UserKeys.lastName] = lastName;
      if (email.isNotEmpty) multiPartRequest.fields[UserKeys.email] = email;
      if (mobile.isNotEmpty) multiPartRequest.fields[UserKeys.mobile] = mobile;
      if (address.isNotEmpty)
        multiPartRequest.fields[UserKeys.address] = address;
      if (gender.isNotEmpty) multiPartRequest.fields[UserKeys.gender] = gender;
      if (dateOfBirth.isNotEmpty)
        multiPartRequest.fields[UserKeys.dateOfBirth] = dateOfBirth;
      if (country.isNotEmpty)
        multiPartRequest.fields[UserKeys.country] = country;
      if (state.isNotEmpty) multiPartRequest.fields[UserKeys.state] = state;
      if (city.isNotEmpty) multiPartRequest.fields[UserKeys.city] = city;
      if (pinCode.isNotEmpty)
        multiPartRequest.fields[UserKeys.pinCode] = pinCode;

      if (imageFile != null) {
        multiPartRequest.files.add(await MultipartFile.fromPath(
            UserKeys.profileImage, imageFile.path));
      }
      log("Multipart ${jsonEncode(multiPartRequest.fields)}");
      log("Multipart Images ${multiPartRequest.files.map((e) => e.filename)}");
      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  // static Future<AboutPageRes> getAboutPageData() async {
  //   return AboutPageRes.fromJson(await handleResponse(await buildHttpResponse(
  //       APIEndPoints.aboutPages,
  //       method: HttpMethodType.GET)));
  // }

  static Future<List<String>> getUserPermissions() async {
    try {
      final response = await buildHttpResponse(
        APIEndPoints.getUserPermissions,
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> permissionsData = data['data'];
        return permissionsData
            .map((permission) => permission as String)
            .toList();
      } else {
        toast(data['message'] ?? locale.value.failedToFetchPermissions);
        return [];
      }
    } catch (e) {
      log('${locale.value.getPermissionsError}$e');
      toast(e.toString());
      return [];
    }
  }
}
