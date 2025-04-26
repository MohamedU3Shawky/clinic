import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egphysio_clinic_admin/api/core_apis.dart';
import 'package:egphysio_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../appointment/appointment_detail_controller.dart';
import '../../appointment/appointments_controller.dart';
import '../../home/home_controller.dart';
import '../../service/model/service_list_model.dart';
import '../generate_invoice/model/billing_item_model.dart';
import '../generate_invoice/model/save_billing_resp.dart';
import '../model/encounters_list_model.dart';
import 'model/billing_details_resp.dart';

enum PaymentStatus { paid, unpaid }

class InvoiceDetailsController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<BillingDetailModel>> getInvoiceDetailFuture = Future(() => BillingDetailModel()).obs;
  Rx<BillingDetailModel> invoiceData = BillingDetailModel().obs;
  Rx<EncounterElement> encounter = EncounterElement().obs;

  //Billing Item TextField Controller
  final GlobalKey<FormState> addBillFormKey = GlobalKey();
  TextEditingController servicesCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController totalCont = TextEditingController();

  //Discount on Billing Items TextField Controller
  final GlobalKey<FormState> finalDiscoutFormKey = GlobalKey();
  TextEditingController finalDiscoutValueCont = TextEditingController();
  RxString finalDiscoutType = DiscountType.PERCENTAGE.obs;
  RxBool enableFinalDiscount = false.obs;

  //Billing Item FocusNode
  FocusNode servicesFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();
  FocusNode totalFocus = FocusNode();

  final GlobalKey<FormState> addinvoiceFormKey = GlobalKey();
  Rx<PaymentStatus> isPaid = PaymentStatus.paid.obs;
  Rx<ServiceElement> selectService = ServiceElement(status: false.obs).obs;
  RxList<BillingItem> billingItemList = RxList();

  RxBool isEditMode = false.obs;

  @override
  void onReady() {
    if (Get.arguments is EncounterElement) {
      encounter(Get.arguments);
      if (encounter.value.status) {
        isEditMode(true);
      }
    }
    getInvoiceDetail();
    super.onReady();
  }

  ///Get Invoice Details
  getInvoiceDetail({bool showLoader = false}) async {
    if (!showLoader) {
      isLoading(true);
    }
    await getInvoiceDetailFuture(CoreServiceApis.getBillingDetails(encounterId: encounter.value.id, billingDetails: invoiceData.value)).then((value) {
      invoiceData(value);
      if (!invoiceData.value.serviceId.isNegative) {
        servicesCont.text = invoiceData.value.serviceName;
        selectService(ServiceElement(status: false.obs, id: invoiceData.value.serviceId, name: invoiceData.value.serviceName));
      }
      billingItemList(invoiceData.value.billingItems);
      setFinalDiscountFormData();
    }).catchError((e) {
      log("getBilling Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  saveGenerateInvoice({bool showLoader = false, bool isFromSaveDiscount = false}) async {
    SaveBillingResp saveBillingDet = SaveBillingResp(
      userId: encounter.value.userId,
      serviceId: invoiceData.value.serviceId,
      paymentStatus: invoiceData.value.paymentStatus,
      encounterId: invoiceData.value.encounterId,
      doctorId: invoiceData.value.doctorId,
      date: invoiceData.value.date,
      clinicId: invoiceData.value.clinicId,
      finalDiscountEnabled: enableFinalDiscount.value,
      finalDiscountType: finalDiscoutType.value,
      finalDiscountValue: finalDiscoutValueCont.text.toDouble(),
    );

    if (showLoader) {
      isLoading(true);
    }
    await CoreServiceApis.saveInvoice(request: saveBillingDet.toJson()).then((value) {
      if (isFromSaveDiscount) {
        Get.back();
      }
     // if (invoiceData.value.paymentStatus == 1) isEditMode(false);
      refreshAppoitmentRelatedPages();
      getInvoiceDetail(showLoader: true);
    }).catchError((e) {
      toast("$e");
    }).whenComplete(() => isLoading(false));
  }

  void refreshAppoitmentRelatedPages() {
    try {
      AppointmentsController acont = Get.find();
      acont.getAppointmentList();
    } catch (e) {
      log('AppointmentDetail updateStatus acont = Get.find() E: $e');
    }

    try {
      AppointmentDetailController appointment = Get.put(AppointmentDetailController());
    //  appointment.init(showLoader: false);
    } catch (e) {
      log('AppointmentDetailController appointment = Get.put(AppointmentDetailController()) E: $e');
    }
    try {
      HomeController hcont = Get.find();
      hcont.getDashboardDetail();
    } catch (e) {
      log('AppointmentDetail updateStatus hcont = Get.find() E: $e');
    }
  }

  setFinalDiscountFormData() {
    enableFinalDiscount(invoiceData.value.enableFinalBillingDiscount);
    finalDiscoutType(invoiceData.value.billingFinalDiscountType);
    finalDiscoutValueCont.text = "${invoiceData.value.billingFinalDiscountValue}";
  }

  getClearBillingItem() {
    servicesCont.clear();
    quantityCont.clear();
    priceCont.clear();
  }

  saveBillingItem({BillingItem? billingItem, required int index, bool showLoader = true}) async {
    if (billingItem == null) {
      billingItem = BillingItem(
        billingId: invoiceData.value.id,
        itemId: selectService.value.id,
        itemName: servicesCont.text.trim(),
        quantity: quantityCont.text.toInt(),
        serviceAmount: priceCont.text.toDouble().toPrecision(2),
        totalAmount: (quantityCont.text.toInt() * priceCont.text.toDouble()).toPrecision(2),
      );
    } else {
      billingItem.quantity = quantityCont.text.toInt();
      billingItem.serviceAmount = priceCont.text.toDouble().toPrecision(2);
      billingItem.totalAmount = (quantityCont.text.toInt() * priceCont.text.toDouble()).toPrecision(2);
    }

    log('saveBillingItem REQ: ${jsonEncode(billingItem.toJson())}');
    if (!showLoader) {
      isLoading(true);
    }
    await CoreServiceApis.saveBillingItems(request: billingItem.toJson()).then((value) {
      toast(value.message.trim().isNotEmpty ? value.message : "Billing Record Saved");
      Get.back();
      getInvoiceDetail(showLoader: true);
      refreshAppoitmentRelatedPages();
    }).catchError((e) {
      toast("$e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleDeleteBillingItemClick({required BuildContext context, required int id}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisBillingItem,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        if (isLoading.value) toast(locale.value.pleaseWaitWhileItsLoading);
        isLoading(true);
        CoreServiceApis.deleteBillingItems(id: id).then((value) {
          getInvoiceDetail(showLoader: true);
          toast(value.message.trim().isEmpty ? locale.value.billingItemRemovedSuccessfully : value.message.trim());
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => isLoading(false));
      },
    );
  }
}
