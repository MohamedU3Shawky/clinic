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
}
