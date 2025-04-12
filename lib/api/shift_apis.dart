import 'dart:convert';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/shift_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/language.dart';

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
        toast(data['message'] ?? language.failedToFetchShifts);
        return [];
      }
    } catch (e) {
      log('${language.getShiftsError}$e');
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
        toast(language.shiftAddedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToAddShift);
        return false;
      }
    } catch (e) {
      log('${language.addShiftError}$e');
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
        toast(language.shiftUpdatedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToUpdateShift);
        return false;
      }
    } catch (e) {
      log('${language.updateShiftError}$e');
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
        toast(language.shiftDeletedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToDeleteShift);
        return false;
      }
    } catch (e) {
      log('${language.deleteShiftError}$e');
      toast(e.toString());
      return false;
    }
  }
}
