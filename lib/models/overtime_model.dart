class OvertimeModel {
  final String id;
  final String from;
  final String to;
  final String type;
  final String? reason;
  final String status;
  final User? reviewedBy;
  final String? reviewedAt;
  final String? createdAt;
  final String? updatedAt;
  final Shift shift;
  final User user;

  OvertimeModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    this.reason,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
    required this.shift,
    required this.user,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeModel(
      id: json['id']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      reason: json['reason']?.toString(),
      status: json['status']?.toString() ?? '',
      reviewedBy:
          json['reviewedBy'] != null ? User.fromJson(json['reviewedBy']) : null,
      reviewedAt: json['reviewedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      shift: Shift.fromJson(json['shift'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
    );
  }
}

class Shift {
  final String id;
  final String startDate;
  final String endDate;
  final TimeTable timeTable;

  Shift({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.timeTable,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      timeTable: TimeTable.fromJson(json['timeTable'] ?? {}),
    );
  }
}

class TimeTable {
  final String id;
  final String name;

  TimeTable({
    required this.id,
    required this.name,
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
