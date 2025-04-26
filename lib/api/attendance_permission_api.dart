import 'package:nb_utils/nb_utils.dart';
import '../models/attendance_permission_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';

class AttendancePermissionApi {
  static Future<Map<String, dynamic>> getAttendancePermissions({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.attendancePermissions}?page=$page&per_page=$perPage',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> permissionsJson = data['data']['data'];
        final permissions = permissionsJson
            .map((json) => AttendancePermissionModel.fromJson(json))
            .toList();

        return {
          'permissions': permissions,
          'totalCount': data['data']['attendancePermissionsCount'],
          'approvedCount': data['data']['approvedAttendancePermissionsCount'],
          'pendingCount': data['data']['pendingAttendancePermissionsCount'],
          'rejectedCount': data['data']['rejectedAttendancePermissionsCount'],
        };
      } else {
        toast(data['message'] ?? "Failed to fetch attendance permissions");
        return {
          'permissions': [],
          'totalCount': 0,
          'approvedCount': 0,
          'pendingCount': 0,
          'rejectedCount': 0,
        };
      }
    } catch (e) {
      log("getAttendancePermissions Error: $e");
      toast(e.toString());
      return {
        'permissions': [],
        'totalCount': 0,
        'approvedCount': 0,
        'pendingCount': 0,
        'rejectedCount': 0,
      };
    }
  }
} 