class AttendanceRecordsModel {
  bool? status;
  String? message;
  Data? data;

  AttendanceRecordsModel({
    this.status,
    this.message,
    this.data,
  });

  factory AttendanceRecordsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<Record>? records;
  int? pageCount;

  Data({
    this.records,
    this.pageCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      records: json['records'] != null
          ? List<Record>.from(json['records'].map((x) => Record.fromJson(x)))
          : [],
      pageCount: json['pageCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'records': records?.map((x) => x.toJson()).toList(),
      'pageCount': pageCount,
    };
  }
}

class Record {
  String? id;
  String? userId;
  User? user;
  String? branchId;
  Branch? branch;
  String? customerId;
  String? checkInDate;
  String? checkOutDate;
  double? checkInLat;
  double? checkInLng;
  double? checkOutLat;
  double? checkOutLng;
  String? qrCode;
  String? doneInById;
  String? doneOutById;
  bool? automatic;
  String? status;
  String? createdAt;
  String? updatedAt;

  Record({
    this.id,
    this.userId,
    this.user,
    this.branchId,
    this.branch,
    this.customerId,
    this.checkInDate,
    this.checkOutDate,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.qrCode,
    this.doneInById,
    this.doneOutById,
    this.automatic,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      branchId: json['branchId'] as String?,
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      customerId: json['customerId'] as String?,
      checkInDate: json['checkInDate'] as String?,
      checkOutDate: json['checkOutDate'] as String?,
      checkInLat: json['checkInLat'] as double?,
      checkInLng: json['checkInLng'] as double?,
      checkOutLat: json['checkOutLat'] as double?,
      checkOutLng: json['checkOutLng'] as double?,
      qrCode: json['QRCode'] as String?,
      doneInById: json['doneInById'] as String?,
      doneOutById: json['doneOutById'] as String?,
      automatic: json['automatic'] as bool?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user?.toJson(),
      'branchId': branchId,
      'branch': branch?.toJson(),
      'customerId': customerId,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'checkInLat': checkInLat,
      'checkInLng': checkInLng,
      'checkOutLat': checkOutLat,
      'checkOutLng': checkOutLng,
      'QRCode': qrCode,
      'doneInById': doneInById,
      'doneOutById': doneOutById,
      'automatic': automatic,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class User {
  String? id;
  String? customerId;
  String? roleId;
  String? permissionValue;
  String? name;
  String? email;
  String? phone;
  String? gender;
  bool? emailVerified;
  String? status;
  String? avatar;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.customerId,
    this.roleId,
    this.permissionValue,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.emailVerified,
    this.status,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      customerId: json['customerId'] as String?,
      roleId: json['roleId'] as String?,
      permissionValue: json['permissionValue'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      status: json['status'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'roleId': roleId,
      'permissionValue': permissionValue,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'emailVerified': emailVerified,
      'status': status,
      'avatar': avatar,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Branch {
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

  Branch({
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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
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
