import '../models/attendance.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/shift_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';

class AttendanceApi {
  Future<AttendanceResponse> getAttendance({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.allAttendance}?from=${from.toIso8601String()}&to=${to.toIso8601String()}',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        return AttendanceResponse.fromJson(data);
      } else {
        toast(data['message'] ?? locale.value.failedToFetchAttendance);
        return AttendanceResponse(
          success: false,
          message: data['message'],
          data: AttendanceData(data: [], pageCount: 0),
        );
      }
    } catch (e) {
      log('${locale.value.getAttendanceError}$e');
      toast(e.toString());
      return AttendanceResponse(
        success: false,
        message: e.toString(),
        data: AttendanceData(data: [], pageCount: 0),
      );
    }
  }
}
