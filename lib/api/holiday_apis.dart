import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/holiday_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/language.dart';

class HolidayServiceApis {
  static Future<List<HolidayModel>> getHolidays(
      DateTime from, DateTime to) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.getHolidays}?from=${from.toIso8601String()}&to=${to.toIso8601String()}',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final holidays = data['data']['data'] as List;
        return holidays.map((e) => HolidayModel.fromJson(e)).toList();
      } else {
        toast(data['message'] ?? "Failed to fetch holidays");
        return [];
      }
    } catch (e) {
      log("getHolidays Error: $e");
      toast(e.toString());
      return [];
    }
  }

  Future<List<HolidayModel>> getHolidaysForMonth(int year, int month) async {
    try {
      // Calculate the first and last day of the month
      final DateTime firstDayOfMonth = DateTime(year, month, 1);
      final DateTime lastDayOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

      // Format dates for the API request
      final String fromDate = firstDayOfMonth.toIso8601String();
      final String toDate = lastDayOfMonth.toIso8601String();

      final response = await buildHttpResponse(
        '${APIEndPoints.getHolidays}?from=$fromDate&to=$toDate',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> holidaysData = data['data']['data'];
        return holidaysData.map((json) => HolidayModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching holidays: $e');
      return [];
    }
  }
}
