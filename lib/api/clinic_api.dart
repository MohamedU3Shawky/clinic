import 'dart:convert';
import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';

import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import '../screens/clinic/model/clinic_detail_model.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../screens/clinic/model/clinic_gallery_model.dart';

class ClinicApis {
  static Future<RxList<ClinicData>> getClinicList({
    String search = '',
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ClinicData> clinicList,
    Function(bool)? lastPageCallBack,
    bool isReceptionistRegister = false,
    bool isDoctorRegister = false,
    int? doctorId,
    bool showAllClinics = false,
  }) async {
    // If showAllClinics is true, we'll use a large perPage value to fetch all clinics at once
    if (showAllClinics) {
      perPage = 100; // Set to a large number to get all clinics
      page = 1;      // Always start from page 1
      search = '';   // Clear any search filter
    }
    
    String searchService = search.isNotEmpty ? '&search=$search' : '';
    String receptionistLogin = isReceptionistRegister ? '&receptionist_login=1' : '';
    
    // When showAllClinics is true, we'll always use the getClinics endpoint
    String endpoint = showAllClinics ? APIEndPoints.getClinics : 
                     (isReceptionistRegister || isDoctorRegister ? APIEndPoints.getClinicListToRegister : APIEndPoints.getClinics);

    log("Making clinic request to endpoint: $endpoint");
    
    dynamic responseData = await handleResponse(
        await buildHttpResponse("${endpoint}?per_page=$perPage&page=$page$searchService$receptionistLogin", method: HttpMethodType.GET));
        
    // Special handling for the specific nested structure we're seeing
    if (responseData is Map && 
        responseData.containsKey('status') && 
        responseData.containsKey('data') &&
        responseData['data'] is Map &&
        responseData['data'].containsKey('data') &&
        responseData['data']['data'] is List &&
        (responseData['data']['data'] as List).isNotEmpty) {
        
      log("Direct handling of nested data.data structure in API method");
      
      // Directly access the nested clinic data
      var clinicObjects = responseData['data']['data'];
      log("Found ${clinicObjects.length} clinics in nested data");
      
      // Create a proper structure that our parser can handle
      responseData = <String, dynamic>{
        'status': true,
        'data': clinicObjects
      };
    }
    
    // Check if response contains session data, which might actually contain clinic info
    if (responseData is Map && 
        !responseData.containsKey('data') && 
        (responseData.containsKey('mon_open') || responseData.containsKey('tue_open') || 
         responseData.containsKey('wed_open') || responseData.containsKey('session_data'))) {
      log("Detected session data format with weekday schedules - attempting to extract clinic information");
      
      Map<String, dynamic> sessionData = Map<String, dynamic>.from(responseData);
      if (responseData.containsKey('session_data')) {
        sessionData = Map<String, dynamic>.from(responseData['session_data']);
      }
      
      // Try to find the clinic ID and name within the session data
      String? clinicId;
      String? clinicName;
      
      // Detect clinic information from weekday data
      bool hasWeekdaySchedule = responseData.keys.any((key) => 
          key.toString().contains('_open') || key.toString().contains('_close'));
          
      if (hasWeekdaySchedule) {
        log("Detected weekday schedule format");
        
        // Find clinic ID from context - use a default if not found
        clinicId = sessionData['clinic_id']?.toString() ?? 
                  sessionData['id']?.toString() ?? 
                  "clinic_from_schedule";
                  
        // If we have a label from a schedule entry, use it to build a name
        String? dayLabel;
        responseData.forEach((key, value) {
          if (value is Map && value.containsKey('label')) {
            dayLabel = value['label']?.toString();
          }
        });
        
        clinicName = sessionData['clinic_name']?.toString() ?? 
                    sessionData['name']?.toString() ?? 
                    "Clinic with ${dayLabel ?? 'Weekly'} Schedule";
        
        log("Created clinic from schedule data: ID=$clinicId, Name=$clinicName");
      } else {
        // These are possible keys where clinic ID/name might be stored
        if (sessionData.containsKey('clinic_id')) {
          clinicId = sessionData['clinic_id'].toString();
        } else if (sessionData.containsKey('id')) {
          clinicId = sessionData['id'].toString();
        }
        
        if (sessionData.containsKey('clinic_name')) {
          clinicName = sessionData['clinic_name'].toString();
        } else if (sessionData.containsKey('name')) {
          clinicName = sessionData['name'].toString();
        } else if (clinicId != null) {
          // Default name if not found
          clinicName = "Clinic $clinicId";
        }
      }
      
      // If we found clinic info, create a synthetic clinic object
      if (clinicId != null && clinicName != null) {
        log("Extracted clinic from session/schedule data: ID=$clinicId, Name=$clinicName");
        
        // Create a clinic object
        Map<String, dynamic> clinicObject = {
          'id': clinicId,
          'name': clinicName,
          'description': 'Clinic with schedule data',
          'status': 1
        };
        
        // Create response in the expected format
        responseData = <String, dynamic>{
          'status': true,
          'data': [clinicObject]
        };
      }
    }
    
    var res = ClinicListRes.fromJson(responseData is Map<String, dynamic> 
        ? responseData 
        : responseData is Map 
            ? Map<String, dynamic>.from(responseData) 
            : <String, dynamic>{'status': false, 'data': []});

    if (page == 1) clinicList.clear();
    
    if (res.data.isNotEmpty) {
      log("Found ${res.data.length} clinics in response");
      
      // Log each clinic for debugging
      for (var clinic in res.data) {
        log("Clinic: id=${clinic.id}, name=${clinic.name}");
      }
      
      clinicList.addAll(res.data.validate());
      log("Clinic list now has ${clinicList.length} clinics");
    } else {
      log("No clinics found in response");
    }

    lastPageCallBack?.call(res.data.validate().length != perPage);
    
    return clinicList.obs;
  }

  static Future<ClinicDetailModel> getClinicDetails({required int clinicId}) async {
    return ClinicDetailModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.getClinicDetails}?clinic_id=$clinicId', method: HttpMethodType.GET)));
  }

  static Future<RxList<ClinicData>> getClinicListWithDoctor({
    int? doctorId,
    String search = '',
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ClinicData> clinicList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchService = search.isNotEmpty ? '&search=$search' : '';
    String doctor = doctorId.toString().isNotEmpty ? '&doctor_id=$doctorId' : '';
    var res = ClinicListRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getClinics}?per_page=$perPage&page=$page$doctor$searchService", method: HttpMethodType.GET)));

    if (page == 1) clinicList.clear();
    clinicList.addAll(res.data.validate());

    lastPageCallBack?.call(res.data.validate().length != perPage);

    return clinicList.obs;
  }

  static Future<dynamic> addEditClinc({
    bool isEdit = false,
    int? clinicId,
    ClinicData? clinicData,
    required Map<String, dynamic> request,
    // List<XFile>? files,
    File? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(isEdit ? "${APIEndPoints.updateClinic}/$clinicId" : APIEndPoints.saveClinic);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
      if (imageFile != null) {
        // multiPartRequest.files.addAll(await getMultipartImages2(files: files.validate(), name: 'feature_image'));
        multiPartRequest.files.add(await MultipartFile.fromPath('file_url', imageFile.path));
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

  static Future<BaseResponseModel> deleteClinic({required int clinicId}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.deleteClinic}/$clinicId', method: HttpMethodType.POST)));
  }

  static Future<RxList<GalleryData>> getClinicGalleryList({
    int page = 1,
    int perPage = 10,
    required List<GalleryData> galleryList,
    Function(bool)? lastPageCallBack,
    int clinicId = -1,
  }) async {
    String clncId = clinicId != -1 ? '&clinic_id=$clinicId' : '';
    final galleryListRes = ClinicGalleryModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getClinicGallery}?per_page=$perPage&page=$page$clncId", method: HttpMethodType.GET)));
    if (page == 1) galleryList.clear();
    galleryList.addAll(galleryListRes.data);
    lastPageCallBack?.call(galleryListRes.data.length != perPage);
    return galleryList.obs;
  }

  //Save Gallery Images
  static Future<dynamic> saveClinicGallery({
    required Map<String, dynamic> request,
    List<File>? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.saveClinicGallery);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
      if (imageFile != null || imageFile!.isNotEmpty) {
        for (var i = 0; i < imageFile.length; i++) {
          multiPartRequest.files.add(await MultipartFile.fromPath('gallery_images[$i]', imageFile[i].path));
        }
      }
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

  //Delete Gallery List
  // static Future<BaseResponseModel> deleteClinicGallery({required Map request}) async {
  //   return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveClinicGallery, request: request, method: HttpMethodType.POST)));
  // }

  static Future<dynamic> deleteClinicGallery({
    required Map<String, dynamic> request,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.saveClinicGallery);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
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

  //Clinic Session List
  static Future<RxList<ClinicSessionModel>> getClinicSessionList({required int clinicId, required List<ClinicSessionModel> clinicSessionResp}) async {
    final resp = ClinicSessionResp.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.clinicSessionList}?clinic_id=$clinicId", method: HttpMethodType.GET)));
    clinicSessionResp.addAll(resp.data);
    return clinicSessionResp.obs;
  }

  //Save Clinic Session
  static Future<RxList<ClinicSessionModel>> saveClinicSession({required Map request, required List<ClinicSessionModel> clinicSessionResp}) async {
    final resp = ClinicSessionResp.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveClinicSession, request: request, method: HttpMethodType.POST)));
    toast(resp.message);
    clinicSessionResp.addAll(resp.data);
    return clinicSessionResp.obs;
  }
}
