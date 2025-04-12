import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../models/leave_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/language.dart';

class LeaveServiceApis {
  static Future<List<LeaveSettingModel>> getLeaveSettings() async {
    try {
      final response = await buildHttpResponse(
        APIEndPoints.getLeaveSettings,
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        final List<dynamic> settingsData = data['data'];
        return settingsData
            .map((setting) => LeaveSettingModel.fromJson(setting))
            .toList();
      } else {
        toast(data['message'] ?? language.failedToFetchLeaves);
        return [];
      }
    } catch (e) {
      log('${language.getLeavesError}$e');
      toast(e.toString());
      return [];
    }
  }

  static Future<LeaveResponseModel> getLeaves(
      DateTime from, DateTime to) async {
    try {
      final fromStr = from.toIso8601String();
      final toStr = to.toIso8601String();

      final response = await buildHttpResponse(
        '${APIEndPoints.getLeaves}?from=$fromStr&to=$toStr',
        method: HttpMethodType.GET,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        return LeaveResponseModel.fromJson(data);
      } else {
        toast(data['message'] ?? language.failedToFetchLeaves);
        return LeaveResponseModel(
          leaves: [],
          leavesCount: 0,
          approvedLeavesCount: 0,
          pendingLeavesCount: 0,
          rejectedLeavesCount: 0,
        );
      }
    } catch (e) {
      log('${language.getLeavesError}$e');
      toast(e.toString());
      return LeaveResponseModel(
        leaves: [],
        leavesCount: 0,
        approvedLeavesCount: 0,
        pendingLeavesCount: 0,
        rejectedLeavesCount: 0,
      );
    }
  }

  static Future<bool> addLeave({
    required String leaveSettingId,
    required DateTime from,
    required DateTime to,
    String? reason,
  }) async {
    try {
      final response = await buildHttpResponse(
        APIEndPoints.addLeave,
        request: {
          'leaveSettingId': leaveSettingId,
          'from': from.toIso8601String(),
          'to': to.toIso8601String(),
          'reason': reason ?? '',
        },
        method: HttpMethodType.POST,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(language.leaveAddedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToAddLeave);
        return false;
      }
    } catch (e) {
      log('${language.addLeaveError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> updateLeave({
    required String leaveId,
    required DateTime from,
    required DateTime to,
    String? reason,
  }) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.updateLeave}/$leaveId',
        request: {
          'from': from.toIso8601String(),
          'to': to.toIso8601String(),
          'reason': reason ?? '',
        },
        method: HttpMethodType.PUT,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(language.leaveUpdatedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToUpdateLeave);
        return false;
      }
    } catch (e) {
      log('${language.updateLeaveError}$e');
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> deleteLeaves(String leaveIds) async {
    try {
      final response = await buildHttpResponse(
        '${APIEndPoints.deleteLeave}?ids=$leaveIds',
        method: HttpMethodType.DELETE,
      );

      final data = await handleResponse(response);

      if (data['success'] == true) {
        toast(language.leaveDeletedSuccessfully);
        return true;
      } else {
        toast(data['message'] ?? language.failedToDeleteLeave);
        return false;
      }
    } catch (e) {
      log('${language.deleteLeaveError}$e');
      toast(e.toString());
      return false;
    }
  }
}
