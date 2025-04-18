import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../configs.dart';
import '../main.dart';
import '../api/auth_apis.dart';
import '../screens/auth/profile/profile_controller.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../utils/shared_preferences.dart';

Map<String, String> buildHeaderTokens({
  Map? extraKeys,
  String? endPoint,
}) {
  /// Initialize & Handle if key is not present
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isFlutterWave', () => false);
    extraKeys.putIfAbsent('isAirtelMoney', () => false);
  }
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Accept': "application/json",
    'global-localization': selectedLanguageCode.value,
  };

  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }
  header.putIfAbsent(
      HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

  // Get the token from SharedPreferences for all authenticated requests
  String? apiToken;

  if (isLoggedIn.value) {
    // First try to get the token from loginUserData
    apiToken = loginUserData.value.apiToken;

    // If not found, try to get it from SharedPreferences
    if (apiToken.isEmpty) {
      try {
        var tokenFromPrefs =
            CashHelper.getData(key: SharedPreferenceConst.API_TOKEN);
        if (tokenFromPrefs != null &&
            tokenFromPrefs is String &&
            tokenFromPrefs.isNotEmpty) {
          apiToken = tokenFromPrefs;
          log('Using API token from SharedPreferences: $apiToken');
        }
      } catch (e) {
        log('Error getting token from SharedPreferences: $e');
      }
    }
  }

  if (isLoggedIn.value &&
      extraKeys.containsKey('isFlutterWave') &&
      extraKeys['isFlutterWave']) {
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => "Bearer ${extraKeys!['flutterWaveSecretKey']}");
  } else if (isLoggedIn.value &&
      extraKeys.containsKey('isAirtelMoney') &&
      extraKeys['isAirtelMoney']) {
    header.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => 'Bearer ${extraKeys!['access_token']}');
    header.putIfAbsent('X-Country', () => '${extraKeys!['X-Country']}');
    header.putIfAbsent('X-Currency', () => '${extraKeys!['X-Currency']}');
  } else if (isLoggedIn.value && apiToken != null && apiToken.isNotEmpty) {
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => 'Bearer $apiToken');
    log('Added authorization header with token: Bearer $apiToken');
  } else if (isLoggedIn.value) {
    // Fallback to loginUserData token, though it might be empty
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => 'Bearer ${loginUserData.value.apiToken}');
    log('Warning: Could not find a valid token for request. Using possibly empty token from loginUserData.');
  }

  log('Request headers: ${jsonEncode(header)}');
  return header;
}

Uri buildBaseUrl(String endPoint) {
  if (!endPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$endPoint');
  } else {
    return Uri.parse(endPoint);
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
}) async {
  var headers = buildHeaderTokens(extraKeys: extraKeys, endPoint: endPoint);
  Uri url = buildBaseUrl(endPoint);

  Response response;
  log('URL (${method.name}): $url');

  // Add extra debugging for clinic-related endpoints
  if (endPoint.contains('branch') || endPoint.contains('get-clinic')) {
    log('Making clinic API request: $url');
    log('Headers: ${jsonEncode(headers)}');
  }

  try {
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response =
          await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.PATCH) {
      response =
          await http.patch(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    // Add extra debugging for clinic-related endpoints
    if (endPoint.contains('branch') || endPoint.contains('get-clinic')) {
      log('Clinic API response code: ${response.statusCode}');
      log('Clinic API response body: ${response.body.trim()}');
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: method.name,
    );
    // log('Response (${method.name}) ${response.statusCode}: ${response.body.trim().trim()}');

    if (isLoggedIn.value &&
        response.statusCode == 401 &&
        !endPoint.startsWith('http')) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(endPoint,
            method: method, request: request, extraKeys: extraKeys);
      }).catchError((e) async {
        if (!await isNetworkAvailable()) {
          throw errorInternetNotAvailable;
        } else {
          throw errorSomethingWentWrong;
        }
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log(e);
    throw errorInternetNotAvailable;
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);

  Map req = {
    UserKeys.email: loginUserData.value.email,
    UserKeys.userType: loginUserData.value.userRole.isNotEmpty
        ? loginUserData.value.userRole.first
        : loginUserData.value.userType,
  };
  if (loginUserData.value.isSocialLogin) {
    log('LOGINUSERDATA.VALUE.ISSOCIALLOGIN: ${loginUserData.value.isSocialLogin}');
    req[UserKeys.loginType] = loginUserData.value.loginType;
  } else {
    req[UserKeys.password] = userPASSWORD;
  }
  return await AuthServiceApis.loginUser(
          request: req, isSocialLogin: loginUserData.value.isSocialLogin)
      .then((value) async {
    loginUserData.value.apiToken = value.userData.apiToken;
  }).catchError((e) {
    ProfileController().handleLogout();
  });
}

Future handleResponse(Response response,
    {HttpResponseType httpResponseType = HttpResponseType.JSON,
    bool? avoidTokenError,
    bool? isFlutterWave}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      Map body = jsonDecode(response.body.trim());

      // Special handling for clinic endpoints
      if (response.request?.url.toString().contains("branch") == true ||
          response.request?.url.toString().contains("get-clinic") == true) {
        log("Special handling for clinic endpoint response");

        // Log the raw response structure to understand its format
        log("Clinic response structure: ${body.keys.toList()}");

        // For debugging purposes, print the full response
        String fullResponse = jsonEncode(body);
        log("Full clinic response: ${fullResponse.substring(0, fullResponse.length > 500 ? 500 : fullResponse.length)}...");

        // Special handling for the specific structure: {"status":true,"message":null,"data":{"data":[...]}}
        if (body.containsKey('status') &&
            body.containsKey('data') &&
            body['data'] is Map &&
            body['data'].containsKey('data') &&
            body['data']['data'] is List) {
          log("Found nested data.data structure with ${body['data']['data'].length} clinic items");

          // Return the structure as is - our model will handle it
          return body;
        }

        // If the response doesn't follow the standard structure but has data
        if (!body.containsKey('status')) {
          // Try to extract data from a non-standard response
          if (body.containsKey('data') && body['data'] is List) {
            log("Found data array in clinic response with ${body['data'].length} items");
            return {"status": true, "data": body['data']};
          } else if (body is List) {
            log("Response is a direct array with ${body.length} items, wrapping in standard format");
            return {"status": true, "data": body};
          } else if (body is Map) {
            // Check if this is a map with clinic data directly
            if (body.containsKey('id') && body.containsKey('name')) {
              // This looks like a single clinic object
              log("Found single clinic object, wrapping in array");
              return {
                "status": true,
                "data": [body]
              };
            }

            // Try to find any key that might contain clinic data
            List<dynamic> possibleClinics = [];
            body.forEach((key, value) {
              if (value is Map &&
                  value.containsKey('id') &&
                  value.containsKey('name')) {
                log("Found clinic in key: $key");
                possibleClinics.add(value);
              } else if (value is List) {
                // Some APIs nest lists inside maps
                for (var item in value) {
                  if (item is Map &&
                      item.containsKey('id') &&
                      item.containsKey('name')) {
                    log("Found clinic in list under key: $key");
                    possibleClinics.add(item);
                  }
                }
              }
            });

            if (possibleClinics.isNotEmpty) {
              log("Extracted ${possibleClinics.length} clinics from various places in the response");
              return {"status": true, "data": possibleClinics};
            }
          }
        }
        // If the response has status = 0 but contains data, we'll still return it
        else if (body.containsKey('data')) {
          if (body['data'] is List && body['data'].isNotEmpty) {
            log("Clinic response has data list with ${body['data'].length} items");
            return {"status": true, "data": body['data']};
          } else if (body['data'] is Map) {
            // Sometimes data might be a map of clinics
            Map<String, dynamic> clinicsMap = body['data'];
            List<dynamic> clinicList = [];

            // Try to extract clinic objects
            clinicsMap.forEach((key, value) {
              if (value is Map &&
                  value.containsKey('id') &&
                  value.containsKey('name')) {
                // This looks like a clinic object
                log("Found clinic with id: ${value['id']} and name: ${value['name']}");
                clinicList.add(value);
              }
            });

            if (clinicList.isNotEmpty) {
              log("Extracted ${clinicList.length} clinics from data map");
              return {"status": true, "data": clinicList};
            }
          }
        }
      }

      if (body.containsKey('status')) {
        if (isFlutterWave.validate()) {
          if (body['status'] == 'success') {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        } else {
          if (body['status'] == true) {
            return body;
          } else {
            if (body.containsKey("is_deleted") && body["is_deleted"] == true) {
              AuthServiceApis.clearData(isFromDeleteAcc: true);
              isLoggedIn(false);
              doIfLoggedIn(() {});
              toast(body['message'] ?? errorSomethingWentWrong);
            } else {
              throw body['message'] ?? errorSomethingWentWrong;
            }
          }
        }
      } else {
        return body;
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (response.statusCode == 400) {
    throw locale.value.badRequest;
  } else if (response.statusCode == 403) {
    throw locale.value.forbidden;
  } else if (response.statusCode == 404) {
    throw locale.value.pageNotFound;
  } else if (response.statusCode == 429) {
    throw locale.value.tooManyRequests;
  } else if (response.statusCode == 500) {
    throw locale.value.internalServerError;
  } else if (response.statusCode == 502) {
    throw locale.value.badGateway;
  } else if (response.statusCode == 503) {
    throw locale.value.serviceUnavailable;
  } else if (response.statusCode == 504) {
    throw locale.value.gatewayTimeout;
  } else {
    Map body = jsonDecode(response.body.trim());

    if (body.containsKey('status') && body['status']) {
      return body;
    } else {
      throw body['message'] ?? errorSomethingWentWrong;
    }
  }
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields(
    {required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  // log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response =
      await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
      url: multiPartRequest.url.toString(),
      headers: jsonEncode(multiPartRequest.headers),
      request: jsonEncode(multiPartRequest.fields),
      hasRequest: true,
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: "MultiPart");
  // log("Result: ${response.statusCode} - ${multiPartRequest.fields}");
  // log(response.body.trim());
  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body.trim());
  } else {
    if (isLoggedIn.value && response.statusCode == 401) {
      return await reGenerateToken().then((value) async {
        try {
          http.Response response =
              await http.Response.fromStream(await multiPartRequest.send());
          if (response.statusCode.isSuccessful()) {
            onSuccess?.call(response.body.trim());
          } else {
            onError?.call(response.reasonPhrase);
          }
        } catch (e) {
          onError?.call(response.reasonPhrase);
        }
      }).catchError((e) {
        onError?.call(response.reasonPhrase);
      });
    } else {
      AuthServiceApis.clearData(isFromDeleteAcc: true);
      doIfLoggedIn(() {});
      onError?.call(response.reasonPhrase);
    }
  }
}

Future<List<MultipartFile>> getMultipartImages(
    {required List<PlatformFile> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<PlatformFile>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath(
        '$name[${i.toString()}]', element.path.validate()));
  });

  return multiPartRequest;
}

Future<List<MultipartFile>> getMultipartImages2(
    {required List<XFile> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<XFile>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath(
        '$name[${i.toString()}]', element.path.validate()));
    log('MultipartFile: $name[${i.toString()}]');
  });

  return multiPartRequest;
}

String parseStripeError(String response) {
  try {
    var body = jsonDecode(response);
    return parseHtmlString(body['error']['message']);
  } on Exception catch (e) {
    log(e);
    throw errorSomethingWentWrong;
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
  bool fullLog = false,
}) {
  if (fullLog) {
    dev.log(
        "┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('Response ($methodtype) $statusCode: $responseBody');
    dev.log("\u001B[0m");
    dev.log(
        "└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('Response ($methodtype) $statusCode: ${formatJson(responseBody)}');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}
