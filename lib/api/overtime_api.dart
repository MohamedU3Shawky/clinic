import 'package:nb_utils/nb_utils.dart';
import '../models/overtime_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';

class OvertimeApi {
  static Future<Map<String, dynamic>> getOvertime({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.overtime}?page=$page&per_page=$perPage',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> overtimeJson = data['data']['data'];
        final overtime = overtimeJson
            .map((json) => OvertimeModel.fromJson(json))
            .toList();

        return {
          'overtime': overtime,
          'totalCount': data['data']['overtimeCount'] ?? 0,
          'approvedCount': data['data']['approvedOvertimeCount'] ?? 0,
          'pendingCount': data['data']['pendingOvertimeCount'] ?? 0,
          'rejectedCount': data['data']['rejectedOvertimeCount'] ?? 0,
        };
      } else {
        toast(data['message'] ?? "Failed to fetch overtime");
        return {
          'overtime': [],
          'totalCount': 0,
          'approvedCount': 0,
          'pendingCount': 0,
          'rejectedCount': 0,
        };
      }
    } catch (e) {
      log("getOvertime Error: $e");
      toast(e.toString());
      return {
        'overtime': [],
        'totalCount': 0,
        'approvedCount': 0,
        'pendingCount': 0,
        'rejectedCount': 0,
      };
    }
  }
} 