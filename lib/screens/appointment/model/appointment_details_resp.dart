import 'appointments_res_model.dart';

class AppointmentDetailsResp {
  bool status;
  AppointmentData data;
  String message;

  AppointmentDetailsResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory AppointmentDetailsResp.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? AppointmentData.fromJson(json['data']) : AppointmentData(
        id: "",
        userId: "",
        user: UserData(id: "", name: "", email: ""),
        clientId: "",
        client: ClientData(id: "", name: "", email: "", phones: [], birthDate: ""),
        branchId: "",
        branch: BranchData(id: "", name: ""),
        specialityId: "",
        speciality: SpecialityData(id: "", name: ""),
        services: [],
        clinicalRoomId: "",
        clinicalRoom: ClinicalRoomData(id: "", name: ""),
        address: "",
        appointmentType: "",
        status: "",
        appointmentDate: "",
        checkedInDate: "",
        createdAt: "",
        updatedAt: "",
      ),
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


class AppointmentMedicalReport {
  int id;
  String url;

  AppointmentMedicalReport({
    this.id = -1,
    this.url = "",
  });

  factory AppointmentMedicalReport.fromJson(Map<String, dynamic> json) {
    return AppointmentMedicalReport(
      id: json['id'] is int ? json['id'] : -1,
      url: json['url'] is String ? json['url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
