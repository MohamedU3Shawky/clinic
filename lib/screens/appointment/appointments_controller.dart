// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../Encounter/add_encounter/model/patient_model.dart';
import '../Encounter/model/encounters_list_model.dart';
import '../doctor/model/doctor_list_res.dart';
import '../home/home_controller.dart';
import '../patient/model/patient_argument_model.dart';
import '../service/model/service_list_model.dart';
import 'model/appointments_res_model.dart';

class AppointmentsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<AppointmentData>>> getAppointments = Future(() => RxList<AppointmentData>()).obs;
  RxList<AppointmentData> appointments = RxList();
  RxInt page = 1.obs;
  Rx<Doctor> selectedDoctor = Doctor().obs;
  Rx<ServiceElement> selectedServiceData = ServiceElement(status: false.obs).obs;
  Rx<PatientModel> selectedPatient = PatientModel().obs;
  RxString status = "".obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  Rx<PatientArgumentModel> patientDetailArgument = PatientArgumentModel(patientModel: PatientModel()).obs;

  RxString viewMode = 'daily'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> weekStartDate = DateTime.now().obs;
  Rx<DateTime> weekEndDate = DateTime.now().obs;

  @override
  void onInit() {
    if (Get.arguments is PatientArgumentModel) {
      patientDetailArgument(Get.arguments);
      selectedPatient(patientDetailArgument.value.patientModel);
    }
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getAppointmentList();
    });
    // Set initial week range
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    weekStartDate.value = now.subtract(Duration(days: weekday - 1));
    weekEndDate.value = now.add(Duration(days: 7 - weekday));
    getAppointmentList(showloader: false);
    super.onInit();
  }

  getAppointmentList({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getAppointments(CoreServiceApis.getAppointmentList(
      filterByStatus: status.value,
      serviceId: selectedServiceData.value.id,
      patientId: selectedPatient.value.id,
      doctorId: selectedDoctor.value.id,
      from: viewMode.value == 'daily' ? selectedDate.value : weekStartDate.value,
      to: viewMode.value == 'daily' ? selectedDate.value : weekEndDate.value,
      clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : null,
      search: searchCont.text.trim(),
      appointments: appointments,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).then((value) {
      // Filter appointments based on selected date or week
      if (viewMode.value == 'daily') {
        appointments.value = appointments.where((appointment) {
          final appointmentDate = DateTime.parse(appointment.appointmentDate);
          return appointmentDate.year == selectedDate.value.year &&
                 appointmentDate.month == selectedDate.value.month &&
                 appointmentDate.day == selectedDate.value.day;
        }).toList();
      } else {
        appointments.value = appointments.where((appointment) {
          final appointmentDate = DateTime.parse(appointment.appointmentDate);
          return appointmentDate.isAfter(weekStartDate.value.subtract(const Duration(days: 1))) && 
                 appointmentDate.isBefore(weekEndDate.value.add(const Duration(days: 1)));
        }).toList();
      }
    }).catchError((e) {
      log('getAppointments E: $e');
    }).whenComplete(() =>
     isLoading(false));
  }

  updateStatus({required String status, required int id, required bool isBack, required BuildContext context, required bool isCheckOut, EncounterElement? encountDetails, Function(BuildContext)? onCallBack}) {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.doYouWantToPerformThisAction,
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        if (isCheckOut) {
          onCallBack!(context);
        } else {
          isLoading(true);
          CoreServiceApis.changeAppointmentStatus(
            id: id,
            request: {'status': postStatus(status: status)},
          ).then((value) {
            toast(value.message.trim().isEmpty ? locale.value.statusHasBeenUpdated : value.message.trim());
            if (isBack) {
              Get.back();
            }
            try {
              HomeController hcont = Get.find();
              hcont.getDashboardDetail();
            } catch (e) {
              log('Appointments updateStatus hcont = Get.find() E: $e');
            }
            getAppointmentList();
          }).catchError((e) {
            isLoading(false);
            toast(e.toString());
          });
        }
      },
    );
  }

  void toggleViewMode() {
    if (viewMode.value == 'daily') {
      // Switching to weekly: set weekStartDate and weekEndDate to the current week
      DateTime now = DateTime.now();
      int weekday = now.weekday;
      DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
      DateTime endOfWeek = now.add(Duration(days: 7 - weekday));
      weekStartDate.value = startOfWeek;
      weekEndDate.value = endOfWeek;
      viewMode.value = 'weekly';
      getAppointmentList();
    } else {
      viewMode.value = 'daily';
      getAppointmentList();
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    getAppointmentList();
  }

  void setWeekDates(DateTime start, DateTime end) {
    weekStartDate.value = start;
    weekEndDate.value = end;
    getAppointmentList();
  }

  @override
  void onClose() {
    searchStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
