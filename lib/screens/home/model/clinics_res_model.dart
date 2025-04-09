class ClinicListRes {
  bool status;
  List<ClinicData> data;
  String message;

  ClinicListRes({
    this.status = false,
    this.data = const <ClinicData>[],
    this.message = "",
  });

  factory ClinicListRes.fromJson(Map<String, dynamic> json) {
    return ClinicListRes(
      status: json['status'] ?? false,
      data: json['data'] != null && json['data']['data'] is List
          ? List<ClinicData>.from(json['data']['data'].map((x) => ClinicData.fromJson(x)))
          : [],
      message: json['message'] ?? "",
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

class ClinicData {
  String? id;
  String? name;
  String? address;
  String? branchLat;
  String? branchLng;
  String? phone;
  String? status;
  String? QRCode;
  String? customerId;
  String? createdAt;
  String? updatedAt;

  ClinicData({
    this.id,
    this.name,
    this.address,
    this.branchLat,
    this.branchLng,
    this.phone,
    this.status,
    this.QRCode,
    this.customerId,
    this.createdAt,
    this.updatedAt,
  });

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    return ClinicData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      branchLat: json['branchLat'] as String?,
      branchLng: json['branchLng'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      QRCode: json['QRCode'] as String?,
      customerId: json['customerId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'branchLat': branchLat,
      'branchLng': branchLng,
      'phone': phone,
      'status': status,
      'QRCode': QRCode,
      'customerId': customerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

