import '../screens/auth/model/change_password_res.dart';
import '../screens/auth/model/login_response.dart';

class RegUserResp {
  bool status;
  Data userData;
  String message;

  RegUserResp({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory RegUserResp.fromJson(Map<String, dynamic> json) {
    return RegUserResp(
      status: json['status'] is bool ? json['status'] : false,
      userData: json['data'] is Map ? Data.fromJson(json['data']) : Data(userData: UserData()),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': userData.toJson(),
      'message': message,
    };
  }
}

class Data {
  String apiToken;
  UserData userData;

  Data({
    this.apiToken = "",
    required this.userData,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      apiToken: json['token'] is String ? json['token'] : "",
      userData: json['user_data'] is Map ? UserData.fromJson(json['user_data']) : UserData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': apiToken,
      'user_data': userData.toJson(),
    };
  }
}
