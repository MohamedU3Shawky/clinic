import '../../../utils/constants.dart';
import '../../Encounter/generate_invoice/model/billing_item_model.dart';
import '../../home/model/dashboard_res_model.dart';
import 'appointment_details_resp.dart';

class AppointmentListRes {
  bool status;
  String? message;
  AppointmentPaginationData data;

  AppointmentListRes({
    this.status = false,
    this.message,
    required this.data,
  });

  factory AppointmentListRes.fromJson(Map<String, dynamic> json) {
    return AppointmentListRes(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'],
      data: json['data'] is Map<String, dynamic> ? AppointmentPaginationData.fromJson(json['data']) : AppointmentPaginationData(data: [], pageCount: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AppointmentPaginationData {
  List<AppointmentData> data;
  int pageCount;

  AppointmentPaginationData({
    required this.data,
    required this.pageCount,
  });

  factory AppointmentPaginationData.fromJson(Map<String, dynamic> json) {
    return AppointmentPaginationData(
      data: json['data'] is List ? List<AppointmentData>.from(json['data'].map((x) => AppointmentData.fromJson(x))) : [],
      pageCount: json['pageCount'] is int ? json['pageCount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pageCount': pageCount,
    };
  }
}

class AppointmentData {
  String id;
  String userId;
  UserData user;
  String clientId;
  ClientData client;
  String branchId;
  BranchData branch;
  String specialityId;
  SpecialityData speciality;
  List<ServiceData> services;
  String clinicalRoomId;
  ClinicalRoomData clinicalRoom;
  String? thirdPartyId;
  ThirdPartyData? thirdParty;
  String address;
  String appointmentType;
  String status;
  String appointmentDate;
  String checkedInDate;
  String createdAt;
  String updatedAt;

  // Legacy fields kept for backward compatibility
  String? startDateTime;
  String? userName;
  String? userImage;
  String? userEmail;
  String? userPhone;
  String? userDob;
  String? userGender;
  int? clinicId;
  String? clinicName;
  int? doctorId;
  String? description;
  String? doctorName;
  String? doctorImage;
  String? doctorPhone;
  String? appointmentTime;
  String? endTime;
  int? duration;
  int? encounterId;
  String? encounterDescription;
  int? serviceId;
  bool? encounterStatus;
  String? serviceName;
  String? serviceType;
  bool? isVideoConsultancy;
  String? serviceImage;
  String? categoryName;
  String? appointmentExtraInfo;
  num? totalAmount;
  num? serviceAmount;
  String? discountType;
  num? discountValue;
  num? discountAmount;
  String? paymentStatus;
  bool? isEnableAdvancePayment;
  num? advancePaymentAmount;
  int? advancePaymentStatus;
  num? advancePaidAmount;
  num? remainingPayableAmount;
  String? zoomLink;
  String? googleLink;
  int? countryId;
  int? stateId;
  int? cityId;
  String? countryName;
  String? stateName;
  String? cityName;
  String? pincode;
  String? clinicImage;
  String? clinicAddress;
  String? clinicPhone;
  String? doctorEmail;
  num? servicePrice;
  num? serviceTotal;
  num? subtotal;
  num? totalTax;
  String? billingFinalDiscountType;
  bool? enableFinalBillingDiscount;
  num? billingFinalDiscountValue;
  num? billingFinalDiscountAmount;
  List<AppointmentMedicalReport>? medicalReport;
  List<TaxPercentage>? taxData;
  List<BillingItem>? billingItems;
  String? notificationId;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;
  String? deletedAt;

  AppointmentData({
    required this.id,
    required this.userId,
    required this.user,
    required this.clientId,
    required this.client,
    required this.branchId,
    required this.branch,
    required this.specialityId,
    required this.speciality,
    required this.services,
    required this.clinicalRoomId,
    required this.clinicalRoom,
    this.thirdPartyId,
    this.thirdParty,
    required this.address,
    required this.appointmentType,
    required this.status,
    required this.appointmentDate,
    required this.checkedInDate,
    required this.createdAt,
    required this.updatedAt,
    
    // Legacy fields
    this.startDateTime,
    this.userName,
    this.userImage,
    this.userEmail,
    this.userPhone,
    this.userDob,
    this.userGender,
    this.clinicId,
    this.clinicName,
    this.doctorId,
    this.description,
    this.doctorName,
    this.doctorImage,
    this.doctorPhone,
    this.appointmentTime,
    this.endTime,
    this.duration,
    this.encounterId,
    this.encounterDescription,
    this.serviceId,
    this.encounterStatus,
    this.serviceName,
    this.serviceType,
    this.isVideoConsultancy,
    this.serviceImage,
    this.categoryName,
    this.appointmentExtraInfo,
    this.totalAmount,
    this.serviceAmount,
    this.discountType,
    this.discountValue,
    this.discountAmount,
    this.paymentStatus,
    this.isEnableAdvancePayment,
    this.advancePaymentAmount,
    this.advancePaymentStatus,
    this.advancePaidAmount,
    this.remainingPayableAmount,
    this.zoomLink,
    this.googleLink,
    this.countryId,
    this.stateId,
    this.cityId,
    this.countryName,
    this.stateName,
    this.cityName,
    this.pincode,
    this.clinicImage,
    this.clinicAddress,
    this.clinicPhone,
    this.doctorEmail,
    this.servicePrice,
    this.serviceTotal,
    this.subtotal,
    this.totalTax,
    this.billingFinalDiscountType,
    this.enableFinalBillingDiscount,
    this.billingFinalDiscountValue,
    this.billingFinalDiscountAmount,
    this.medicalReport,
    this.taxData,
    this.billingItems,
    this.notificationId,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.deletedAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] is String ? json['id'] : "",
      userId: json['userId'] is String ? json['userId'] : "",
      user: json['user'] is Map<String, dynamic> ? UserData.fromJson(json['user']) : UserData(id: "", name: "", email: ""),
      clientId: json['clientId'] is String ? json['clientId'] : "",
      client: json['client'] is Map<String, dynamic> ? ClientData.fromJson(json['client']) : ClientData(id: "", name: "", email: "", phones: [], birthDate: ""),
      branchId: json['branchId'] is String ? json['branchId'] : "",
      branch: json['branch'] is Map<String, dynamic> ? BranchData.fromJson(json['branch']) : BranchData(id: "", name: ""),
      specialityId: json['specialityId'] is String ? json['specialityId'] : "",
      speciality: json['speciality'] is Map<String, dynamic> ? SpecialityData.fromJson(json['speciality']) : SpecialityData(id: "", name: ""),
      services: json['services'] is List ? List<ServiceData>.from(json['services'].map((x) => ServiceData.fromJson(x))) : [],
      clinicalRoomId: json['clinicalRoomId'] is String ? json['clinicalRoomId'] : "",
      clinicalRoom: json['clinicalRoom'] is Map<String, dynamic> ? ClinicalRoomData.fromJson(json['clinicalRoom']) : ClinicalRoomData(id: "", name: ""),
      thirdPartyId: json['thirdPartyId'] is String ? json['thirdPartyId'] : null,
      thirdParty: json['thirdParty'] is Map<String, dynamic> ? ThirdPartyData.fromJson(json['thirdParty']) : null,
      address: json['address'] is String ? json['address'] : "",
      appointmentType: json['appointmentType'] is String ? json['appointmentType'] : "",
      status: json['status'] is String ? json['status'] : "",
      appointmentDate: json['appointmentDate'] is String ? json['appointmentDate'] : "",
      checkedInDate: json['checkedInDate'] is String ? json['checkedInDate'] : "",
      createdAt: json['createdAt'] is String ? json['createdAt'] : "",
      updatedAt: json['updatedAt'] is String ? json['updatedAt'] : "",
      
      // Parse legacy fields for backward compatibility
      startDateTime: json['start_date_time'] is String ? json['start_date_time'] : null,
      userName: json['user_name'] is String ? json['user_name'] : null,
      userImage: json['user_image'] is String ? json['user_image'] : null,
      userEmail: json['user_email'] is String ? json['user_email'] : null,
      userPhone: json['user_phone'] is String ? json['user_phone'] : null,
      userDob: json['user_dob'] is String ? json['user_dob'] : null,
      userGender: json['user_gender'] is String ? json['user_gender'] : null,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : null,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : null,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : null,
      description: json['description'] is String ? json['description'] : null,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : null,
      doctorImage: json['doctor_image'] is String ? json['doctor_image'] : null,
      doctorPhone: json['doctor_phone'] is String ? json['doctor_phone'] : null,
      appointmentTime: json['appointment_time'] is String ? json['appointment_time'] : null,
      endTime: json['end_time'] is String ? json['end_time'] : null,
      duration: json['duration'] is int ? json['duration'] : null,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : null,
      encounterDescription: json['encounter_description'] is String ? json['encounter_description'] : null,
      serviceId: json['service_id'] is int ? json['service_id'] : null,
      encounterStatus: json['encounter_status'] is bool ? json['encounter_status'] : json['encounter_status'] == 1 ? true : null,
      serviceName: json['service_name'] is String ? json['service_name'] : null,
      serviceType: json['service_type'] is String ? json['service_type'] : null,
      isVideoConsultancy: json['is_video_consultancy'] is bool ? json['is_video_consultancy'] : json['is_video_consultancy'] == 1 ? true : null,
      serviceImage: json['service_image'] is String ? json['service_image'] : null,
      categoryName: json['category_name'] is String ? json['category_name'] : null,
      appointmentExtraInfo: json['appointment_extra_info'] is String ? json['appointment_extra_info'] : null,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : null,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : null,
      discountType: json['discount_type'] is String ? json['discount_type'] : null,
      discountValue: json['discount_value'] is num ? json['discount_value'] : null,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : null,
      paymentStatus: json['payment_status'] is String ? json['payment_status'] : null,
      isEnableAdvancePayment: json['is_enable_advance_payment'] is bool ? json['is_enable_advance_payment'] : json['is_enable_advance_payment'] == 1 ? true : null,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : null,
      advancePaymentStatus: json['advance_payment_status'] is int ? json['advance_payment_status'] : null,
      advancePaidAmount: json['advance_paid_amount'] is num ? json['advance_paid_amount'] : null,
      remainingPayableAmount: json['remaining_payable_amount'] is num ? json['remaining_payable_amount'] : null,
      zoomLink: json['zoom_link'] is String ? json['zoom_link'] : null,
      googleLink: json['google_link'] is String ? json['google_link'] : null,
      countryId: json['country_id'] is int ? json['country_id'] : null,
      stateId: json['state_id'] is int ? json['state_id'] : null,
      cityId: json['city_id'] is int ? json['city_id'] : null,
      countryName: json['country_name'] is String ? json['country_name'] : null,
      stateName: json['state_name'] is String ? json['state_name'] : null,
      cityName: json['city_name'] is String ? json['city_name'] : null,
      pincode: json['pincode'] is String ? json['pincode'] : null,
      clinicImage: json['clinic_image'] is String ? json['clinic_image'] : null,
      clinicAddress: json['clinic_address'] is String ? json['clinic_address'] : null,
      clinicPhone: json['clinic_phone'] is String ? json['clinic_phone'] : null,
      doctorEmail: json['doctor_email'] is String ? json['doctor_email'] : null,
      servicePrice: json['service_price'] is num ? json['service_price'] : null,
      serviceTotal: json['service_total'] is num ? json['service_total'] : null,
      subtotal: json['subtotal'] is num ? json['subtotal'] : null,
      totalTax: json['total_tax'] is num ? json['total_tax'] : null,
      billingFinalDiscountType: json['billing_final_discount_type'] is String ? json['billing_final_discount_type'] : null,
      enableFinalBillingDiscount: json['enable_final_billing_discount'] is bool ? json['enable_final_billing_discount'] : json['enable_final_billing_discount'] == 1 ? true : null,
      billingFinalDiscountValue: json['billing_final_discount_value'] is num ? json['billing_final_discount_value'] : null,
      billingFinalDiscountAmount: json['billing_final_discount_amount'] is num ? json['billing_final_discount_amount'] : null,
      medicalReport: json['medical_report'] is List ? List<AppointmentMedicalReport>.from(json['medical_report'].map((x) => AppointmentMedicalReport.fromJson(x))) : null,
      taxData: json['tax_data'] is List ? List<TaxPercentage>.from(json['tax_data'].map((x) => TaxPercentage.fromJson(x))) : null,
      billingItems: json['billing_items'] is List ? List<BillingItem>.from(json['billing_items'].map((x) => BillingItem.fromJson(x))) : null,
      notificationId: json['notificationId'] is String ? json['notificationId'] : null,
      createdBy: json['created_by'] is int ? json['created_by'] : null,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : null,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : null,
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'userId': userId,
      'user': user.toJson(),
      'clientId': clientId,
      'client': client.toJson(),
      'branchId': branchId,
      'branch': branch.toJson(),
      'specialityId': specialityId,
      'speciality': speciality.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
      'clinicalRoomId': clinicalRoomId,
      'clinicalRoom': clinicalRoom.toJson(),
      'address': address,
      'appointmentType': appointmentType,
      'status': status,
      'appointmentDate': appointmentDate,
      'checkedInDate': checkedInDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };

    if (thirdPartyId != null) json['thirdPartyId'] = thirdPartyId;
    if (thirdParty != null) json['thirdParty'] = thirdParty!.toJson();

    // Add legacy fields if they exist
    if (startDateTime != null) json['start_date_time'] = startDateTime;
    if (userName != null) json['user_name'] = userName;
    if (userImage != null) json['user_image'] = userImage;
    if (userEmail != null) json['user_email'] = userEmail;
    if (userPhone != null) json['user_phone'] = userPhone;
    if (userDob != null) json['user_dob'] = userDob;
    if (userGender != null) json['user_gender'] = userGender;
    if (clinicId != null) json['clinic_id'] = clinicId;
    if (clinicName != null) json['clinic_name'] = clinicName;
    if (doctorId != null) json['doctor_id'] = doctorId;
    if (description != null) json['description'] = description;
    if (doctorName != null) json['doctor_name'] = doctorName;
    if (doctorImage != null) json['doctor_image'] = doctorImage;
    if (doctorPhone != null) json['doctor_phone'] = doctorPhone;
    if (appointmentTime != null) json['appointment_time'] = appointmentTime;
    if (endTime != null) json['end_time'] = endTime;
    if (duration != null) json['duration'] = duration;
    if (encounterId != null) json['encounter_id'] = encounterId;
    if (encounterDescription != null) json['encounter_description'] = encounterDescription;
    if (serviceId != null) json['service_id'] = serviceId;
    if (encounterStatus != null) json['encounter_status'] = encounterStatus! ? 1 : 0;
    if (serviceName != null) json['service_name'] = serviceName;
    if (serviceType != null) json['service_type'] = serviceType;
    if (isVideoConsultancy != null) json['is_video_consultancy'] = isVideoConsultancy! ? 1 : 0;
    if (serviceImage != null) json['service_image'] = serviceImage;
    if (categoryName != null) json['category_name'] = categoryName;
    if (appointmentExtraInfo != null) json['appointment_extra_info'] = appointmentExtraInfo;
    if (totalAmount != null) json['total_amount'] = totalAmount;
    if (serviceAmount != null) json['service_amount'] = serviceAmount;
    if (discountType != null) json['discount_type'] = discountType;
    if (discountValue != null) json['discount_value'] = discountValue;
    if (discountAmount != null) json['discount_amount'] = discountAmount;
    if (paymentStatus != null) json['payment_status'] = paymentStatus;
    if (isEnableAdvancePayment != null) json['is_enable_advance_payment'] = isEnableAdvancePayment! ? 1 : 0;
    if (advancePaymentAmount != null) json['advance_payment_amount'] = advancePaymentAmount;
    if (advancePaymentStatus != null) json['advance_payment_status'] = advancePaymentStatus;
    if (advancePaidAmount != null) json['advance_paid_amount'] = advancePaidAmount;
    if (remainingPayableAmount != null) json['remaining_payable_amount'] = remainingPayableAmount;
    if (zoomLink != null) json['zoom_link'] = zoomLink;
    if (googleLink != null) json['google_link'] = googleLink;
    if (countryId != null) json['country_id'] = countryId;
    if (stateId != null) json['state_id'] = stateId;
    if (cityId != null) json['city_id'] = cityId;
    if (countryName != null) json['country_name'] = countryName;
    if (stateName != null) json['state_name'] = stateName;
    if (cityName != null) json['city_name'] = cityName;
    if (pincode != null) json['pincode'] = pincode;
    if (clinicImage != null) json['clinic_image'] = clinicImage;
    if (clinicAddress != null) json['clinic_address'] = clinicAddress;
    if (clinicPhone != null) json['clinic_phone'] = clinicPhone;
    if (doctorEmail != null) json['doctor_email'] = doctorEmail;
    if (servicePrice != null) json['service_price'] = servicePrice;
    if (serviceTotal != null) json['service_total'] = serviceTotal;
    if (subtotal != null) json['subtotal'] = subtotal;
    if (totalTax != null) json['total_tax'] = totalTax;
    if (billingFinalDiscountType != null) json['billing_final_discount_type'] = billingFinalDiscountType;
    if (enableFinalBillingDiscount != null) json['enable_final_billing_discount'] = enableFinalBillingDiscount! ? 1 : 0;
    if (billingFinalDiscountValue != null) json['billing_final_discount_value'] = billingFinalDiscountValue;
    if (billingFinalDiscountAmount != null) json['billing_final_discount_amount'] = billingFinalDiscountAmount;
    if (medicalReport != null) json['medical_report'] = medicalReport!.map((e) => e.toJson()).toList();
    if (taxData != null) json['tax_data'] = taxData!.map((e) => e.toJson()).toList();
    if (billingItems != null) json['billing_items'] = billingItems!.map((e) => e.toJson()).toList();
    if (notificationId != null) json['notificationId'] = notificationId;
    if (createdBy != null) json['created_by'] = createdBy;
    if (updatedBy != null) json['updated_by'] = updatedBy;
    if (deletedBy != null) json['deleted_by'] = deletedBy;
    if (deletedAt != null) json['deleted_at'] = deletedAt;

    return json;
  }
}

class UserData {
  String id;
  String name;
  String email;

  UserData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
      email: json['email'] is String ? json['email'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class ClientData {
  String id;
  String name;
  String email;
  List<String> phones;
  String birthDate;

  ClientData({
    required this.id,
    required this.name,
    required this.email,
    required this.phones,
    required this.birthDate,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
      email: json['email'] is String ? json['email'] : "",
      phones: json['phones'] is List ? List<String>.from(json['phones']) : [],
      birthDate: json['birthDate'] is String ? json['birthDate'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phones': phones,
      'birthDate': birthDate,
    };
  }
}

class BranchData {
  String id;
  String name;

  BranchData({
    required this.id,
    required this.name,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SpecialityData {
  String id;
  String name;

  SpecialityData({
    required this.id,
    required this.name,
  });

  factory SpecialityData.fromJson(Map<String, dynamic> json) {
    return SpecialityData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ServiceData {
  String id;
  String name;
  num cost;
  int duration;

  ServiceData({
    required this.id,
    required this.name,
    required this.cost,
    required this.duration,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
      cost: json['cost'] is num ? json['cost'] : 0,
      duration: json['duration'] is int ? json['duration'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'duration': duration,
    };
  }
}

class ClinicalRoomData {
  String id;
  String name;

  ClinicalRoomData({
    required this.id,
    required this.name,
  });

  factory ClinicalRoomData.fromJson(Map<String, dynamic> json) {
    return ClinicalRoomData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ThirdPartyData {
  String id;
  String name;

  ThirdPartyData({
    required this.id,
    required this.name,
  });

  factory ThirdPartyData.fromJson(Map<String, dynamic> json) {
    return ThirdPartyData(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
