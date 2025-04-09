class IsCheckedModel {
  bool? status;
  String? message;
  Data? data;

  IsCheckedModel({
    this.status,
    this.message,
    this.data,
  });

  factory IsCheckedModel.fromJson(Map<String, dynamic> json) {
    return IsCheckedModel(
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
  bool? isCheckedIn;

  Data({this.isCheckedIn});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      isCheckedIn: json['isCheckedIn'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCheckedIn': isCheckedIn,
    };
  }
}
