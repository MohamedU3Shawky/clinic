import '../../../home/model/dashboard_res_model.dart';
import '../../generate_invoice/model/billing_item_model.dart';

class BillingDetailsResp {
  bool status;
  BillingDetailModel data;
  String message;

  BillingDetailsResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory BillingDetailsResp.fromJson(Map<String, dynamic> json) {
    return BillingDetailsResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? BillingDetailModel.fromJson(json['data']) : BillingDetailModel(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class BillingDetailModel {
  int id;
  int encounterId;
  int userId;
  String userName;
  String userAddress;
  String userGender;
  String userDob;
  int clinicId;
  String clinicName;
  String clinicAddress;
  String clinicEmail;
  int doctorId;
  String doctorName;
  int serviceId;
  String serviceName;
  num servicePrice;
  num serviceAmount;
  num totalAmount;
  num subTotal;
  num finalTotalAmount;
  num discountAmount;
  String discountType;
  num discountValue;
  bool isEnableAdvancePayment;
  num advancePaymentAmount;
  int advancePaymentStatus;
  num advancePaidAmount;
  num remainingPayableAmount;
  String billingFinalDiscountType;
  bool enableFinalBillingDiscount;
  num billingFinalDiscountValue;
  num billingFinalDiscountAmount;
  List<TaxPercentage> taxData;
  List<BillingItem> billingItems;
  num totalTax;
  String date;
  int paymentStatus;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  BillingDetailModel({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.userName = "",
    this.userAddress = "",
    this.userGender = "",
    this.userDob = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.clinicAddress = "",
    this.clinicEmail = "",
    this.doctorId = -1,
    this.doctorName = "",
    this.serviceId = -1,
    this.serviceName = "",
    this.serviceAmount = 0,
    this.servicePrice = 0,
    this.totalAmount = 0,
    this.subTotal = 0,
    this.finalTotalAmount = 0,
    this.discountAmount = 0,
    this.discountType = "",
    this.discountValue = 0,
    this.isEnableAdvancePayment = false,
    this.advancePaymentAmount = 0,
    this.advancePaymentStatus = 0,
    this.advancePaidAmount = 0,
    this.remainingPayableAmount = 0,
    this.billingFinalDiscountType = "",
    this.enableFinalBillingDiscount = false,
    this.billingFinalDiscountValue = 0,
    this.billingFinalDiscountAmount = 0,
    this.taxData = const <TaxPercentage>[],
    this.billingItems = const <BillingItem>[],
    this.totalTax = 0,
    this.date = "",
    this.paymentStatus = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory BillingDetailModel.fromJson(Map<String, dynamic> json) {
    return BillingDetailModel(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userName: json['user_name'] is String ? json['user_name'] : "",
      userAddress: json['user_address'] is String ? json['user_address'] : "",
      userGender: json['user_gender'] is String ? json['user_gender'] : "",
      userDob: json['user_dob'] is String ? json['user_dob'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      clinicEmail: json['clinic_email'] is String ? json['clinic_email'] : "",
      clinicAddress: json['clinic_address'] is String ? json['clinic_address'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      servicePrice: json['service_price'] is num ? json['service_price'] : 0,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      subTotal: json['sub_total'] is num ? json['sub_total'] : 0,
      finalTotalAmount: json['final_total'] is num ? json['final_total'] : 0,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      isEnableAdvancePayment: json['is_enable_advance_payment'] is bool ? json['is_enable_advance_payment'] : json['is_enable_advance_payment'] == 1,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : 0,
      advancePaymentStatus: json['advance_payment_status'] is int ? json['advance_payment_status'] : 0,
      advancePaidAmount: json['advance_paid_amount'] is num ? json['advance_paid_amount'] : 0,
      remainingPayableAmount: json['remaining_payable_amount'] is num ? json['remaining_payable_amount'] : 0,
      billingFinalDiscountType: json['billing_final_discount_type'] is String ? json['billing_final_discount_type'] : "",
      enableFinalBillingDiscount: json['enable_final_billing_discount'] is bool ? json['enable_final_billing_discount'] : json['enable_final_billing_discount'] == 1,
      billingFinalDiscountValue: json['billing_final_discount_value'] is num ? json['billing_final_discount_value'] : 0,
      billingFinalDiscountAmount: json['billing_final_discount_amount'] is num ? json['billing_final_discount_amount'] : 0,
      taxData: json['tax_data'] is List ? List<TaxPercentage>.from(json['tax_data'].map((x) => TaxPercentage.fromJson(x))) : [],
      billingItems: json['billing_items'] is List ? List<BillingItem>.from(json['billing_items'].map((x) => BillingItem.fromJson(x))) : [],
      totalTax: json['total_tax'] is num ? json['total_tax'] : 0,
      date: json['date'] is String ? json['date'] : "",
      paymentStatus: json['payment_status'] is int ? json['payment_status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'user_name': userName,
      'user_address': userAddress,
      'user_gender': userGender,
      'user_dob': userDob,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'clinic_email': clinicEmail,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'service_id': serviceId,
      'service_name': serviceName,
      'service_amount': serviceAmount,
      'total_amount': totalAmount,
      'sub_total': subTotal,
      'discount_amount': discountAmount,
      'discount_type': discountType,
      'discount_value': discountValue,
      'is_enable_advance_payment': isEnableAdvancePayment ? 1 : 0,
      'advance_payment_amount': advancePaymentAmount,
      'advance_payment_status': advancePaymentStatus,
      'advance_paid_amount': advancePaidAmount,
      'remaining_payable_amount': remainingPayableAmount,
      'billing_final_discount_type': billingFinalDiscountType,
      'enable_final_billing_discount': enableFinalBillingDiscount ? 1 : 0,
      'billing_final_discount_value': billingFinalDiscountValue,
      'billing_final_discount_amount': billingFinalDiscountAmount,
      'tax_data': taxData.map((e) => e.toJson()).toList(),
      'billing_items': billingItems.map((e) => e.toJson()).toList(),
      'total_tax': totalTax,
      'date': date,
      'payment_status': paymentStatus,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
