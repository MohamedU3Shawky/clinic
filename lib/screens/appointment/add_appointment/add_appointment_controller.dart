import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/core_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../Encounter/add_encounter/model/patient_model.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../../service/model/service_list_model.dart';
import '../appointments_controller.dart';
import '../model/appointments_res_model.dart';
import '../model/save_payment_req.dart';
import 'booking_success_screen.dart';

class AddAppointmentController extends GetxController {
  TextEditingController clinicCenterCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  FocusNode clinicCenterFocus = FocusNode();
  FocusNode servicesFocus = FocusNode();

  Rx<ClinicData> selectedClinic = ClinicData().obs;

  Rx<ServiceElement> selectedService = ServiceElement(status: false.obs).obs;

  TextEditingController searchCont = TextEditingController();
  TextEditingController patientCont = TextEditingController();

  FocusNode patientFocus = FocusNode();

  RxBool isLoading = false.obs;

  RxBool saveBtnVisible = false.obs;

  final GlobalKey<FormState> addAppointmentformKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  Rx<Doctor> doctorData = Doctor().obs;
  Rx<ClinicData> clinicData = ClinicData().obs;
  Rx<AppointmentData> appointment = AppointmentData(
    id: "",
    userId: "",
    user: UserData(id: "", name: "", email: ""),
    clientId: "",
    client: ClientData(id: "", name: "", email: "", phones: [], birthDate: ""),
    branchId: "",
    branch: BranchData(id: "", name: ""),
    specialityId: "",
    speciality: SpecialityData(id: "", name: ""),
    services: [],
    clinicalRoomId: "",
    clinicalRoom: ClinicalRoomData(id: "", name: ""),
    address: "",
    appointmentType: "",
    status: "",
    appointmentDate: "",
    checkedInDate: "",
    createdAt: "",
    updatedAt: "",
    advancePaymentAmount: 0,
    advancePaymentStatus: 0,
  ).obs;

  //Date & Timeslot
  Rx<Future<RxList<String>>> slotsFuture = Future(() => RxList<String>()).obs;
  RxList<String> slots = RxList();
  RxString selectedDate = DateTime.now().formatDateYYYYmmdd().obs;
  RxString selectedSlot = "".obs;

  //Patient
  RxList<PatientModel> patientList = RxList();
  RxBool isPatientLastPage = false.obs;
  RxInt patientPage = 1.obs;
  Rx<PatientModel> selectPatient = PatientModel().obs;
  RxString searchPatient = "".obs;

  //Error Patient
  RxBool hasErrorFetchingPatient = false.obs;
  RxString errorMessagePatient = "".obs;

  @override
  void onInit() async {
    if (Get.arguments is Doctor) {
      doctorData(Get.arguments as Doctor);
    }
    getPatientList(showloader: true);
    super.onInit();
  }

  Future<void> saveBooking() async {
    isLoading(false);
    hideKeyBoardWithoutContext();

    log("clinic id-----------------${selectedAppClinic.value.id}");
    log("service id-----------------${selectedService.value.id}");
    log("selecetd date-----------------${selectedDate.value.trim()}");
    log("Time slot-----------------${selectedSlot.value}");
    log("patient id-----------------${selectPatient.value.id}");
    log("doctor id-----------------${doctorData.value.doctorId}");
    log("description date-----------------${clinicData.value.description.toString()}");
    log("appointment status-----------------${appointment.value.status.toString()}");
    Map<String, dynamic> request = {
      "clinic_id": selectedAppClinic.value.id.toString(),
      "service_id": selectedService.value.id.toString(),
      "appointment_date": selectedDate.value.trim().toString(),
      "user_id": selectPatient.value.id.toString(),
      "status": appointment.value.status.toString(),
      "doctor_id": doctorData.value.doctorId.toString(),
      "appointment_time": selectedSlot.value.toString(),
      "description": clinicData.value.description.toString()
    };
    log("request----------------$request");
    await CoreServiceApis.saveBookApi(request: request).then(
      (value) {
        CoreServiceApis.savePayment(
          request: SavePaymentReq(
            id: saveBookingRes.value.saveBookingResData.id,
            externalTransactionId: "",
            transactionType: PaymentMethods.PAYMENT_METHOD_CASH,
            taxPercentage: appConfigs.value.taxPercentage.toList(),
            paymentStatus: 0,
            advancePaymentAmount: appointment.value.advancePaymentAmount ?? 0,
            advancePaymentStatus: appointment.value.advancePaymentStatus ?? 0,
            remainingPaymentAmount: 0,
          ).toJson(),
        ).then((value) async {}).catchError((e) {
          toast(e.toString(), print: true);
        }).whenComplete(() {
          onSuccess();
        });
      },
    );
  }

  void onSuccess() async {
    isLoading(false);
    reLoadBookingsOnDashboard();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offUntil(
        GetPageRoute(
            page: () => BookingSuccessScreen(),
            binding: BindingsBuilder(() {
              setStatusBarColor(transparentColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark);
            })),
        (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
  }

  void reLoadBookingsOnDashboard() {
    try {
      AppointmentsController aCont = Get.find();
      aCont.getAppointmentList();
    } catch (e) {
      log('E: $e');
    }
    try {
      DashboardController dashboardController = Get.find();
      dashboardController.currentIndex(1);
      dashboardController.reloadBottomTabs();
    } catch (e) {
      log('E: $e');
    }
  }

  Future<void> getTimeSlot({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }

    /// Get Time Slots Api Call
    await slotsFuture(
      CoreServiceApis.getTimeSlots(
        slots: slots,
        date: selectedDate.value,
        serviceId: selectedService.value.id,
        clinicId: getClinicId,
        doctorId: doctorData.value.doctorId,
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      isLoading(false);
      log("getTimeSlots error $e");
    }).whenComplete(() => isLoading(false));
  }

  int get getClinicId => loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : selectedClinic.value.id;

  void onDateTimeChange() {
    final appointmentDateTime = "${selectedDate.value} ${selectedSlot.value}";
    if (appointmentDateTime.isValidDateTime) {
      saveBtnVisible(true);
    } else {
      saveBtnVisible(false);
    }
  }

  getPatientList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await CoreServiceApis.getPatientsList(
      patientsList: patientList,
      page: patientPage.value,
      search: searchPatient.value,
      filter: "all",
      lastPageCallBack: (p0) {
        isPatientLastPage(p0);
      },
    ).then((value) {
      hasErrorFetchingPatient(false);
    }).catchError((e) {
      hasErrorFetchingPatient(true);
      errorMessagePatient(e.toString());
      toast("Error: $e");
      log("getPatientsList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  //----------------------------------------Price Calculation-----------------------------------
  AssignDoctor get finalAssignDoctor => selectedService.value.assignDoctor.firstWhere(
        (element) => element.doctorId == doctorData.value.doctorId,
        orElse: () => AssignDoctor(
          priceDetail: PriceDetail(
            servicePrice: selectedService.value.charges,
            serviceAmount: selectedService.value.charges,
            discountAmount: selectedService.value.discountAmount,
            discountType: selectedService.value.discountType,
            discountValue: selectedService.value.discountValue,
            totalAmount: selectedService.value.payableAmount,
            duration: selectedService.value.duration,
          ),
        ),
      );

  double get fixedTaxAmount => appConfigs.value.taxPercentage.where((element) => element.type.toLowerCase().contains(TaxType.FIXED.toLowerCase())).sumByDouble((p0) => p0.value.validate());

  double get percentTaxAmount => appConfigs.value.taxPercentage.where((element) {
        return element.type.toLowerCase().contains(TaxType.PERCENT.toLowerCase());
      }).sumByDouble((p0) {
        return ((selectedService.value.assignDoctor.isNotEmpty ? finalAssignDoctor.priceDetail.serviceAmount * p0.value.validate() : selectedService.value.payableAmount * p0.value.validate()) / 100);
      });

  num get totalTax => (fixedTaxAmount + percentTaxAmount).toStringAsFixed(Constants.DECIMAL_POINT).toDouble();

  num get totalAmount => (selectedService.value.assignDoctor.isNotEmpty ? finalAssignDoctor.priceDetail.serviceAmount + totalTax : selectedService.value.payableAmount + totalTax);

  num get advancePayableAmount => (totalAmount * selectedService.value.advancePaymentAmount) / 100;

  num get remainingAmountAfterService => totalAmount - advancePayableAmount;
}
