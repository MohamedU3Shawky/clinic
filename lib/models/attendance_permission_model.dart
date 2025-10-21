class AttendancePermissionModel {
  final String id;
  final int duration;
  final String status;
  final UserModel user;
  final ShiftModel shift;
  final UserModel? reviewedBy;
  final String? reason;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendancePermissionModel({
    required this.id,
    required this.duration,
    required this.status,
    required this.user,
    required this.shift,
    this.reviewedBy,
    this.reason,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendancePermissionModel.fromJson(Map<String, dynamic> json) {
    return AttendancePermissionModel(
      id: json['id'] as String,
      duration: json['duration'] as int,
      status: json['status'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      shift: ShiftModel.fromJson(json['shift'] as Map<String, dynamic>),
      reviewedBy: json['reviewedBy'] != null
          ? UserModel.fromJson(json['reviewedBy'] as Map<String, dynamic>)
          : null,
      reason: json['reason'] as String?,
      type:
          json['type'] as String? ?? 'latein', // Default value if not provided
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(), // Default to current time if not provided
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(), // Default to current time if not provided
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String? ?? '', // Handle null avatar
    );
  }
}

class ShiftModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final TimeTableModel timeTable;

  ShiftModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.timeTable,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      timeTable:
          TimeTableModel.fromJson(json['timeTable'] as Map<String, dynamic>),
    );
  }
}

class TimeTableModel {
  final String id;
  final String name;
  final String checkInTime;
  final String checkOutTime;

  TimeTableModel({
    required this.id,
    required this.name,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
      id: json['id'] as String,
      name: json['name'] as String,
      checkInTime: json['checkInTime'] as String,
      checkOutTime: json['checkOutTime'] as String,
    );
  }
}
