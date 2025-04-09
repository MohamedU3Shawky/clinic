import 'package:nb_utils/nb_utils.dart';
import '../network/network_utils.dart';
import '../screens/home/model/attendance_model.dart';
import '../screens/home/model/attendance_records_model.dart';
import '../screens/home/model/dashboard_res_model.dart';
import '../screens/home/model/ischecked_model.dart';
import '../screens/home/model/revenue_resp.dart';
import '../utils/api_end_points.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../utils/shared_preferences.dart';

class CommonResponse {
  bool status;
  String message;
  
  CommonResponse({this.status = false, this.message = ''});
  
  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : '',
    );
  }
}

class HomeServiceApis {

  static Future<AttendanceModel> checkIn({
    required Map request,
  }) async {
    var res = AttendanceModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.checkIn,request: request, method: HttpMethodType.POST)));
    return res;
  }

  static Future<AttendanceModel> checkOut({
    required Map request,

  }) async {
    var res = AttendanceModel.fromJson(await handleResponse(await buildHttpResponse(
        "${APIEndPoints.checkOut}/${CashHelper.getData(key:SharedPreferenceConst.USER_ID)}"
        ,request: request, method: HttpMethodType.PUT)));
        return res;
  }

  static Future<IsCheckedModel> isChecked() async {

    var res = IsCheckedModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.isChecked}/${CashHelper.getData(key:SharedPreferenceConst.USER_ID)}",
            method: HttpMethodType.GET)));
    return res;
  }

  static Future<AttendanceRecordsModel> getAttendanceRecords(
      {  int page = 1,
        int perPage = 8,
        int? clinicId,
        Function(bool)? lastPageCallBack,}) async {

    var res = AttendanceRecordsModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.allAttendance}?per_page=$perPage&page=$page&createdAt=desc&branch=${CashHelper.getData(key:SharedPreferenceConst.CLINIC_ID)}&userId=${CashHelper.getData(key:SharedPreferenceConst.USER_ID)}",
            method: HttpMethodType.GET)));
    return res;
  }

  static Future<DashboardRes> getDashboard() async {
    var res = DashboardRes.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.vendorDashboardList, method: HttpMethodType.GET)));
    return res;
  }

  static Future<RevenueModel> getRevenueChart() async {
    var res = RevenueModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.revenueDetails, method: HttpMethodType.GET)));
    return res;
  }

  static Future<CommonResponse> updateAppointmentStatus({required Map<String, dynamic> request}) async {
    var res = CommonResponse.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.updateStatus, request: request, method: HttpMethodType.POST)));
    return res;
  }
}
