import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListRes {
  bool status;
  List<ServiceElement> data;
  String message;

  ServiceListRes({
    this.status = false,
    this.data = const <ServiceElement>[],
    this.message = "",
  });

  factory ServiceListRes.fromJson(Map<String, dynamic> json) {
    return ServiceListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<ServiceElement>.from(json['data'].map((x) => ServiceElement.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

// class ServiceElement {
//   int id;
//   String name;
//   String slug;
//   String description;
//   num charges;
//   RxBool status;
//   int categoryId;
//   int subCategoryId;
//   int vendorId;
//   String categoryName;
//   String subcategoryName;
//   int duration;
//   bool discount;
//   int featured;
//   String discountType;
//   num discountValue;
//   num discountAmount;
//   num payableAmount;
//   String timeSlot;
//   bool isVideoConslutcy;
//   String serviceImage;
//   int createdBy;
//   int updatedBy;
//   int deletedBy;
//   String createdAt;
//   String updatedAt;
//   String deletedAt;

//   ServiceElement({
//     this.id = -1,
//     this.name = "",
//     this.slug = "",
//     this.description = "",
//     this.charges = 0,
//     required this.status,
//     this.categoryId = -1,
//     this.subCategoryId = -1,
//     this.vendorId = -1,
//     this.categoryName = "",
//     this.subcategoryName = "",
//     this.duration = -1,
//     this.discount = false,
//     this.featured = -1,
//     this.discountType = "",
//     this.discountValue = 0.0,
//     this.discountAmount = 0.0,
//     this.payableAmount = 0,
//     this.timeSlot = "",
//     this.isVideoConslutcy = false,
//     this.serviceImage = "",
//     this.createdBy = -1,
//     this.updatedBy = -1,
//     this.deletedBy = -1,
//     this.createdAt = "",
//     this.updatedAt = "",
//     this.deletedAt = "",
//   });

//   factory ServiceElement.fromJson(Map<String, dynamic> json) {
//     return ServiceElement(
//       id: json['id'] is int ? json['id'] : -1,
//       name: json['name'] is String ? json['name'] : "",
//       slug: json['slug'] is String ? json['slug'] : "",
//       description: json['description'] is String ? json['description'] : "",
//       charges: json['charges'] is num ? json['charges'] : 0,
//       status: ((json['status'] is bool ? json['status'] : json['status'] == 1) as bool).obs,
//       categoryId: json['category_id'] is int ? json['category_id'] : -1,
//       subCategoryId: json['sub_category_id'] is int ? json['sub_category_id'] : -1,
//       vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
//       categoryName: json['category_name'] is String ? json['category_name'] : "",
//       subcategoryName: json['subcategory_name'] is String ? json['subcategory_name'] : "",
//       duration: json['duration'] is int ? json['duration'] : -1,
//       discount: json['discount'] is bool ? json['discount'] : json['discount'] == 1,
//       featured: json['featured'] is int ? json['featured'] : -1,
//       discountType: json['discount_type'] is String ? json['discount_type'] : "",
//       discountValue: json['discount_value'] is num ? json['discount_value'] : 0.0,
//       discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0.0,
//       payableAmount: json['payable_amount'] is num ? json['payable_amount'] : 0,
//       timeSlot: json['time_slot'] is String ? json['time_slot'] : "",
//       isVideoConslutcy: json['is_video_conslutcy'] is bool ? json['is_video_conslutcy'] : json['is_video_conslutcy'] == 1,
//       serviceImage: json['service_image'] is String ? json['service_image'] : "",
//       createdBy: json['created_by'] is int ? json['created_by'] : -1,
//       updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
//       deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
//       createdAt: json['created_at'] is String ? json['created_at'] : "",
//       updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
//       deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'slug': slug,
//       'description': description,
//       'charges': charges,
//       'status': status.value.getIntBool(),
//       'category_id': categoryId,
//       'sub_category_id': subCategoryId,
//       'vendor_id': vendorId,
//       'category_name': categoryName,
//       'subcategory_name': subcategoryName,
//       'duration': duration,
//       'discount': discount,
//       'featured': featured,
//       'discount_type': discountType,
//       'discount_value': discountValue,
//       'discount_amount': discountAmount,
//       'payable_amount': payableAmount,
//       'time_slot': timeSlot,
//       'is_video_conslutcy': isVideoConslutcy.getIntBool(), //TODO Spell Mistake
//       'service_image': serviceImage,
//       'created_by': createdBy,
//       'updated_by': updatedBy,
//       'deleted_by': deletedBy,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'deleted_at': deletedAt,
//     };
//   }
// }
class ServiceElement {
  int id;
  String name;
  int systemServiceId;
  String slug;
  String description;
  num charges;
  num doctorCharges;
  RxBool status;
  int categoryId;
  int subcategoryId;
  int vendorId;
  String categoryName;
  String subcategoryName;
  int duration;
  bool discount;
  int featured;
  String discountType;
  num discountValue;
  num discountAmount;
  num payableAmount;
  bool isEnableAdvancePayment;
  num advancePaymentAmount;
  List<AssignDoctor> assignDoctor;
  String timeSlot;
  int isVideoConsultancy;
  String type;
  String serviceImage;

  ServiceElement({
    this.id = -1,
    this.name = "",
    this.systemServiceId = -1,
    this.slug = "",
    this.description = "",
    this.charges = 0,
    this.doctorCharges = 0,
    required this.status,
    this.categoryId = -1,
    this.subcategoryId = -1,
    this.vendorId = -1,
    this.categoryName = "",
    this.subcategoryName = "",
    this.duration = -1,
    this.discount = false,
    this.featured = -1,
    this.discountType = "",
    this.discountValue = 0,
    this.discountAmount = 0,
    this.payableAmount = 0,
    this.isEnableAdvancePayment = false,
    this.advancePaymentAmount = 0.0,
    this.assignDoctor = const <AssignDoctor>[],
    this.timeSlot = "",
    this.isVideoConsultancy = -1,
    this.type = "",
    this.serviceImage = "",
  });

  factory ServiceElement.fromJson(Map<String, dynamic> json) {
    return ServiceElement(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      systemServiceId: json['system_service_id'] is int ? json['system_service_id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      description: json['description'] is String ? json['description'] : "",
      charges: json['charges'] is num ? json['charges'] : 0,
      doctorCharges: json['doctor_charges'] is num ? json['doctor_charges'] : 0,
      status: ((json['status'] is bool ? json['status'] : json['status'] == 1) as bool).obs,
      categoryId: json['category_id'] is int ? json['category_id'] : -1,
      subcategoryId: json['subcategory_id'] is int ? json['subcategory_id'] : -1,
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
      categoryName: json['category_name'] is String ? json['category_name'] : "",
      subcategoryName: json['subcategory_name'] is String ? json['subcategory_name'] : "",
      duration: json['duration'] is int ? json['duration'] : -1,
      discount: json['discount'] is bool ? json['discount'] : json['discount'] == 1,
      featured: json['featured'] is int ? json['featured'] : -1,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
      payableAmount: json['payable_amount'] is num ? json['payable_amount'] : 0,
      isEnableAdvancePayment: json['is_enable_advance_payment'] is bool ? json['is_enable_advance_payment'] : json['is_enable_advance_payment'] == 1,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : 0,
      assignDoctor: json['assign_doctor'] is List ? List<AssignDoctor>.from(json['assign_doctor'].map((x) => AssignDoctor.fromJson(x))) : [],
      timeSlot: json['time_slot'] is String ? json['time_slot'] : "",
      isVideoConsultancy: json['is_video_consultancy'] is int ? json['is_video_consultancy'] : -1,
      type: json['type'] is String ? json['type'] : "",
      serviceImage: json['service_image'] is String ? json['service_image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'system_service_id': systemServiceId,
      'slug': slug,
      'description': description,
      'charges': charges,
      'doctor_charges': doctorCharges,
      'status': status.value.getIntBool(),
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'vendor_id': vendorId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'duration': duration,
      'discount': discount,
      'featured': featured,
      'discount_type': discountType,
      'discount_value': discountValue,
      'discount_amount': discountAmount,
      'payable_amount': payableAmount,
      'is_enable_advance_payment': isEnableAdvancePayment,
      'advance_payment_amount': advancePaymentAmount,
      'assign_doctor': assignDoctor.map((e) => e.toJson()).toList(),
      'time_slot': timeSlot,
      'is_video_consultancy': isVideoConsultancy,
      'type': type,
      'service_image': serviceImage,
    };
  }
}

class AssignDoctor {
  int id;
  int serviceId;
  int clinicId;
  int doctorId;
  num charges;
  String name;
  String doctorName;
  String clinicName;
  String doctorProfile;
  PriceDetail priceDetail;

  AssignDoctor({
    this.id = -1,
    this.serviceId = -1,
    this.clinicId = -1,
    this.doctorId = -1,
    this.charges = 0,
    this.name = "",
    this.doctorName = "",
    this.clinicName = "",
    this.doctorProfile = "",
    required this.priceDetail,
  });

  factory AssignDoctor.fromJson(Map<String, dynamic> json) {
    return AssignDoctor(
      id: json['id'] is int ? json['id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      charges: json['charges'] is num ? json['charges'] : 0,
      name: json['name'] is String ? json['name'] : "",
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorProfile: json['doctor_profile'] is String ? json['doctor_profile'] : "",
      priceDetail: json['price_detail'] is Map ? PriceDetail.fromJson(json['price_detail']) : PriceDetail(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'charges': charges,
      'name': name,
      'doctor_name': doctorName,
      'clinic_name': clinicName,
      'doctor_profile': doctorProfile,
      'price_detail': priceDetail.toJson(),
    };
  }
}

class PriceDetail {
  num servicePrice;
  num serviceAmount;
  num totalAmount;
  int duration;
  String discountType;
  num discountValue;
  num discountAmount;

  PriceDetail({
    this.servicePrice = -1,
    this.serviceAmount = -1,
    this.totalAmount = -1,
    this.duration = -1,
    this.discountType = "",
    this.discountValue = 0,
    this.discountAmount = 0,
  });

  factory PriceDetail.fromJson(Map<String, dynamic> json) {
    return PriceDetail(
      servicePrice: json['service_price'] is num ? json['service_price'] : 0,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      duration: json['duration'] is int ? json['duration'] : -1,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_price': servicePrice,
      'service_amount': serviceAmount,
      'total_amount': totalAmount,
      'duration': duration,
      'discount_type': discountType,
      'discount_value': discountValue,
      'discount_amount': discountAmount,
    };
  }
}
