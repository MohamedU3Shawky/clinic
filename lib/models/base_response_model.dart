class BaseResponseModel {
  bool status;
  String message;

  BaseResponseModel({
    this.status = false,
    this.message = "",
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      status: json['status'] is bool ? json['status'] : false,
      message: json['data']['message'] is String ? json['data']['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
