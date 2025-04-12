class ScheduleModel {
  final String id;
  final String title;
  final String startDate;
  final String endDate;
  final String status;
  final String type;
  final String? description;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.type,
    this.description,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      status: json['status'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'type': type,
      'description': description,
    };
  }
}
