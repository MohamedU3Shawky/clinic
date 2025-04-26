import 'dart:convert';
import 'package:http/http.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/shift_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';

class ShiftServiceApis {
  static Future<List<ShiftModel>> getShifts({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.getShifts}?startDate=$startDate&endDate=$endDate',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> shiftsData = data['data']['data'];
        return shiftsData.map((shift) => ShiftModel.fromJson(shift)).toList();
      } else {
        toast(data['message'] ?? locale.value.failedToFetchShifts);
        return [];
      }
    } catch (e) {
      log('${locale.value.getShiftsError}$e');
      toast(e.toString());
      return [];
    }
  }

  static Future<bool> addShift(ShiftModel shift) async {
    try {
      final response = await buildHttpResponse(
        APIEndPoints.addShift,
        request: shift.toJson(),
        method: HttpMethodType.POST,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(locale.value.shiftAddedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? locale.value.failedToAddShift);
        return false;
      }
    } catch (e) {
      log('${locale.value.addShiftError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> updateShift(ShiftModel shift) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.updateShift}/${shift.id}',
        request: shift.toJson(),
        method: HttpMethodType.PUT,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(locale.value.shiftUpdatedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? locale.value.failedToUpdateShift);
        return false;
      }
    } catch (e) {
      log('${locale.value.updateShiftError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> deleteShift(String id) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.deleteShift}/$id',
        method: HttpMethodType.DELETE,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(locale.value.shiftDeletedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? locale.value.failedToDeleteShift);
        return false;
      }
    } catch (e) {
      log('${locale.value.deleteShiftError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> checkIn({
    required String userId,
    required String shiftId,
    required double checkInLat,
    required double checkInLng,
    String? qrCode,
  }) async {
    try {
      final response = await buildHttpResponse(
        APIEndPoints.checkIn,
        request: {
          'userId': userId,
          'shiftId': shiftId,
          'checkInLat': checkInLat,
          'checkInLng': checkInLng,
          if (qrCode != null) 'QRCode': qrCode,
        },
        method: HttpMethodType.POST,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(locale.value.checkInSuccess);
        return true;
      } else {
        toast(data['message'] ?? locale.value.checkInFailed);
        return false;
      }
    } catch (e) {
      log('${locale.value.checkInError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> checkOut({
    required String attendanceId,
    required String userId,
    required String shiftId,
    required double checkOutLat,
    required double checkOutLng,
    String? qrCode,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.checkOut}/$attendanceId',
        request: {
          'userId': userId,
          'shiftId': shiftId,
          'checkOutLat': checkOutLat,
          'checkOutLng': checkOutLng,
          if (qrCode != null) 'QRCode': qrCode,
        },
        method: HttpMethodType.PUT,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(locale.value.checkOutSuccess);
        return true;
      } else {
        toast(data['message'] ?? locale.value.checkOutFailed);
        return false;
      }
    } catch (e) {
      log('${locale.value.checkOutError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> isCheckedIn(String shiftId) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.isChecked}?shiftId=$shiftId',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);
      return data['data'] == true;
    } catch (e) {
      log('${locale.value.checkStatusError}$e');
      return false;
    }
  }
}
