import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:egphysio_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:egphysio_clinic_admin/utils/app_common.dart';
import '../../../../api/core_apis.dart';
import '../../../../utils/constants.dart';
import '../../../doctor/model/doctor_list_res.dart';
import '../../../service/model/service_list_model.dart';

class BillingServicesController extends GetxController {
  Rx<Future<RxList<ServiceElement>>> serviceListFuture = Future(() => RxList<ServiceElement>()).obs;
  RxBool isLoading = false.obs;
  RxList<ServiceElement> serviceList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  RxBool isSearchServiceText = false.obs;
  TextEditingController searchServiceCont = TextEditingController();

  StreamController<String> searchServiceStream = StreamController<String>();
  final _scrollController = ScrollController();

  Rx<Doctor> doctorData = Doctor().obs;
  Rx<ClinicData> clinicData = ClinicData().obs;

  RxList<ServiceElement> selecteService = RxList();
  Rx<ServiceElement> singleServiceSelect = ServiceElement(status: false.obs).obs;

  RxString appBarTitle = locale.value.services.obs;

  @override
  void onInit() {
    try {
      if (Get.arguments is ServiceElement) {
        singleServiceSelect(Get.arguments);
      }
    } catch (e) {
      log('AllServicesCont Get.arguments onInit E: $e');
    }

    super.onInit();
  }

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchServiceStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getAllServices();
    });
    getAllServices();
    super.onReady();
  }

  Future<void> getAllServices({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        page: page.value,
        serviceList: serviceList,
        clinicId: clinicData.value.id.isNegative && loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : clinicData.value.id,
        doctorId: doctorData.value.doctorId,
        search: searchServiceCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      getDoctorCharges();
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getServiceList Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  void getDoctorCharges() {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
      try {
        for (var service in serviceList) {
          for (var assignDoctor in service.assignDoctor) {
            if (assignDoctor.doctorId == loginUserData.value.id && assignDoctor.clinicId == selectedAppClinic.value.id && assignDoctor.serviceId == service.id) {
              service.doctorCharges = assignDoctor.charges;
            }
          }
        }
      } catch (e) {
        log('getServicePrice Errr: $e');
      }
    }
  }

  @override
  void onClose() {
    searchServiceStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
