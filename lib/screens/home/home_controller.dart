import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/home/model/attendance_records_model.dart';
import 'model/revenue_chart_data.dart';
import 'model/dashboard_res_model.dart';
import '../../api/home_apis.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';
import 'model/attendance_model.dart';
import 'model/revenue_resp.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt currentPage = 1.obs;
  RxInt pageCount = 0.obs;
  Rx<Future<AttendanceRecordsModel>> attendanceRecords = Future(() => AttendanceRecordsModel()).obs;
  RxList<Record> recordList = RxList();
  TextEditingController searchCont = TextEditingController();
  PageController pageController = PageController();
  PageController recentAppointmentPageController = PageController();
  PageController clinicsPageController = PageController();
  PageController servicesPageController = PageController();
  RxInt currentAppoinmentPage = 0.obs;
  RxInt currentServicePage = 0.obs;
  RxString chartValue = "".obs;
  RxList<String> revenueList = <String>['Daily', 'Weekly', 'Monthly', 'Yearly'].obs;
  Rx<List<RevenueChartData>> chartData = Rx<List<RevenueChartData>>([]);
  Rx<DashboardRes> dashboardData = DashboardRes(data: DashboardData()).obs;
  Rx<Future<DashboardRes>> getDashboardDetailFuture = Future<DashboardRes>(() => DashboardRes(data: DashboardData())).obs;
  Rx<RevenueModel> revenueData = RevenueModel().obs;

  RxBool showAddServiceComp = false.obs;

  @override
  void onInit() {
   getAttendanceRecords();
   getDashboardDetail();
   getRevenueChartDetails();
    super.onInit();
  }
  @override
  void onReady() {

    super.onReady();
  }

  ///Get ChooseService List
  getDashboardDetail({bool showLoader = true,}) async {
    if (showLoader) {
      isLoading(true);
    }
    getDashboardDetailFuture(HomeServiceApis.getDashboard());
    await HomeServiceApis.getDashboard()
        .then((value) {
           dashboardData(value);
           log("Dashboard data loaded successfully");
         })
        .catchError((e) {
          log("getDashboard api err $e");
        })
        .whenComplete(() => isLoading(false));
  }



  getAttendanceRecords({bool showLoader = true,}) async{
    if (showLoader) {
      isLoading(true);
    }
    await attendanceRecords(HomeServiceApis.getAttendanceRecords(
      page: currentPage.value,
    ))
        .then((value){
                    pageCount(value.data!.pageCount);
                   recordList.addAll((value.data!.records!));
             log("getAttendanceRecords api success ${value.data!.records![0].id}");
          })
        .catchError((e) {
      log("getAttendanceRecords api err $e");
    }).whenComplete(() => isLoading(false));
  }


  ///Timer functions

  var checkInTime = DateTime.now().obs; // Observable check-in time
  var checkOutTime = Rxn<DateTime>(); // Observable check-out time, can be null
  var elapsedTime = Duration.zero.obs; // Observable elapsed time
  Timer? _timer; // Timer object

  void checkIn() {
    checkInTime.value = DateTime.now();
    checkOutTime.value = null; // Reset check-out time
    startTimer(); // Start the timer
  }

  void checkOut() {
    checkOutTime.value = DateTime.now();
    _timer?.cancel(); // Stop the timer
    updateElapsedTime(); // Update the elapsed time when checking out
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime.value = DateTime.now().difference(checkInTime.value);
    });
  }

  void updateElapsedTime() {
    if (checkOutTime.value != null) {
      elapsedTime.value = checkOutTime.value!.difference(checkInTime.value);
    }
  }

  String get formattedElapsedTime {
    final hours = elapsedTime.value.inHours.toString().padLeft(2, '0');
    final minutes = (elapsedTime.value.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsedTime.value.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
  
  void revenueFilter({required String value}) {
    chartValue.value = value;
    // Add your filter implementation here
    log("Selected revenue filter: $value");
  }
  
  void updateStatus({required int id, required String status, required BuildContext context, bool isBack = true}) {
    isLoading(true);
    
    Map<String, dynamic> request = {
      'appointment_id': id.toString(),
      'appointment_status': status,
    };
    
    HomeServiceApis.updateAppointmentStatus(request: request)
      .then((value) {
        getDashboardDetail(showLoader: false);
        if (isBack) Get.back();
      })
      .catchError((e) {
        toast(e.toString(), print: true);
      })
      .whenComplete(() => isLoading(false));
  }

  void getRevenueChartDetails({bool showLoader = true}) {
    if (showLoader) {
      isLoading(true);
    }
    
    HomeServiceApis.getRevenueChart()
      .then((value) {
        revenueData(value as RevenueModel?);
        chartData(value?.data.yearChartData);
        log("Revenue chart data loaded successfully");
      })
      .catchError((e) {
        log("getRevenueChart err: $e");
      })
      .whenComplete(() => isLoading(false));
  }
}