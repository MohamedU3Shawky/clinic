class AttendanceModel {
  bool? status;
  String? message;
  String? dataMessage;

  AttendanceModel({
    this.status,
    this.message,
    this.dataMessage,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      dataMessage: json['data']["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': dataMessage,
    };
  }
}
