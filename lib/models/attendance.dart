class AttendanceResponse {
  final bool success;
  final String? message;
  final AttendanceData data;

  AttendanceResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: AttendanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class AttendanceData {
  final List<EmployeeAttendance> data;
  final int pageCount;

  AttendanceData({
    required this.data,
    required this.pageCount,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => EmployeeAttendance.fromJson(item))
              .toList() ??
          [],
      pageCount: json['pageCount'] != null
          ? int.tryParse(json['pageCount'].toString()) ?? 0
          : 0,
    );
  }
}

class EmployeeAttendance {
  final User user;
  final List<DayAttendance> days;

  EmployeeAttendance({
    required this.user,
    required this.days,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) {
    return EmployeeAttendance(
      user: User.fromJson(json['user'] ?? {}),
      days: (json['days'] as List<dynamic>?)
              ?.map((day) => DayAttendance.fromJson(day))
              .toList() ??
          [],
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
    );
  }
}

class DayAttendance {
  final DateTime date;
  final String status;
  final int? workedMinutes;
  final Holiday? holiday;
  final Shift? shift;
  final List<AttendanceRecord>? attendance;
  final Leave? leave;

  DayAttendance({
    required this.date,
    required this.status,
    this.workedMinutes,
    this.holiday,
    this.shift,
    this.attendance,
    this.leave,
  });

  factory DayAttendance.fromJson(Map<String, dynamic> json) {
    return DayAttendance(
      date: DateTime.parse(
          json['date']?.toString() ?? DateTime.now().toIso8601String()),
      status: json['status']?.toString() ?? 'no shift',
      workedMinutes: json['workedMinutes'] != null
          ? int.tryParse(json['workedMinutes'].toString())
          : null,
      holiday:
          json['holiday'] != null ? Holiday.fromJson(json['holiday']) : null,
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      attendance: json['attendance'] != null
          ? (json['attendance'] as List<dynamic>)
              .map((att) => AttendanceRecord.fromJson(att))
              .toList()
          : null,
      leave: json['leave'] != null ? Leave.fromJson(json['leave']) : null,
    );
  }
}

class AttendanceRecord {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final bool? automatic;

  AttendanceRecord({
    this.checkInDate,
    this.checkOutDate,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.automatic,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      checkInDate: json['checkInDate'] != null
          ? DateTime.parse(json['checkInDate'])
          : null,
      checkOutDate: json['checkOutDate'] != null
          ? DateTime.parse(json['checkOutDate'])
          : null,
      checkInLat: json['checkInLat']?.toDouble(),
      checkInLng: json['checkInLng']?.toDouble(),
      checkOutLat: json['checkOutLat']?.toDouble(),
      checkOutLng: json['checkOutLng']?.toDouble(),
      automatic: json['automatic'],
    );
  }
}

class Leave {
  final String id;
  final String type;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;

  Leave({
    required this.id,
    required this.type,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.status,
    this.approvedBy,
    this.approvedAt,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      fromDate: DateTime.parse(
          json['fromDate']?.toString() ?? DateTime.now().toIso8601String()),
      toDate: DateTime.parse(
          json['toDate']?.toString() ?? DateTime.now().toIso8601String()),
      status: json['status']?.toString() ?? '',
      approvedBy: json['approvedBy']?.toString(),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
    );
  }
}

class Holiday {
  final String name;
  final String reason;

  Holiday({
    required this.name,
    required this.reason,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class Shift {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String recurrenceRule;
  final List<String> weekDays;
  final ShiftDay? currentDay;

  Shift({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.recurrenceRule,
    required this.weekDays,
    this.currentDay,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startDate: DateTime.parse(
          json['startDate']?.toString() ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(
          json['endDate']?.toString() ?? DateTime.now().toIso8601String()),
      recurrenceRule: json['recurrenceRule']?.toString() ?? '',
      weekDays: (json['weekDays'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      currentDay: json['currentDay'] != null
          ? ShiftDay.fromJson(json['currentDay'])
          : null,
    );
  }
}

class ShiftDay {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime punchFrom;
  final DateTime punchTo;
  final bool enableOT;
  final int earlyInOTThreshold;
  final int lateOutOTThreshold;
  final DateTime earlyInOTThresholdDate;
  final DateTime lateOutOTThresholdDate;
  final bool allowLateIn;
  final int lateInThreshold;
  final DateTime lateInThresholdDate;
  final bool allowEarlyOut;
  final int earlyOutThreshold;
  final DateTime earlyOutThresholdDate;
  final DateTime? breakStartTime;
  final DateTime? breakEndTime;
  final bool isBreakPaid;
  final bool useFirstCheckInLastOutOnly;

  ShiftDay({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.punchFrom,
    required this.punchTo,
    required this.enableOT,
    required this.earlyInOTThreshold,
    required this.lateOutOTThreshold,
    required this.earlyInOTThresholdDate,
    required this.lateOutOTThresholdDate,
    required this.allowLateIn,
    required this.lateInThreshold,
    required this.lateInThresholdDate,
    required this.allowEarlyOut,
    required this.earlyOutThreshold,
    required this.earlyOutThresholdDate,
    this.breakStartTime,
    this.breakEndTime,
    required this.isBreakPaid,
    required this.useFirstCheckInLastOutOnly,
  });

  factory ShiftDay.fromJson(Map<String, dynamic> json) {
    return ShiftDay(
      id: json['id']?.toString() ?? '',
      startDate: DateTime.parse(
          json['startDate']?.toString() ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(
          json['endDate']?.toString() ?? DateTime.now().toIso8601String()),
      punchFrom: DateTime.parse(
          json['punchFrom']?.toString() ?? DateTime.now().toIso8601String()),
      punchTo: DateTime.parse(
          json['punchTo']?.toString() ?? DateTime.now().toIso8601String()),
      enableOT: json['enableOT'] ?? false,
      earlyInOTThreshold: json['earlyInOTThreshold'] ?? 0,
      lateOutOTThreshold: json['lateOutOTThreshold'] ?? 0,
      earlyInOTThresholdDate: DateTime.parse(
          json['earlyInOTThresholdDate']?.toString() ??
              DateTime.now().toIso8601String()),
      lateOutOTThresholdDate: DateTime.parse(
          json['lateOutOTThresholdDate']?.toString() ??
              DateTime.now().toIso8601String()),
      allowLateIn: json['allowLateIn'] ?? false,
      lateInThreshold: json['lateInThreshold'] ?? 0,
      lateInThresholdDate: DateTime.parse(
          json['lateInThresholdDate']?.toString() ??
              DateTime.now().toIso8601String()),
      allowEarlyOut: json['allowEarlyOut'] ?? false,
      earlyOutThreshold: json['earlyOutThreshold'] ?? 0,
      earlyOutThresholdDate: DateTime.parse(
          json['earlyOutThresholdDate']?.toString() ??
              DateTime.now().toIso8601String()),
      breakStartTime: json['breakStartTime'] != null
          ? DateTime.parse(json['breakStartTime'])
          : null,
      breakEndTime: json['breakEndTime'] != null
          ? DateTime.parse(json['breakEndTime'])
          : null,
      isBreakPaid: json['isBreakPaid'] ?? false,
      useFirstCheckInLastOutOnly: json['useFirstCheckInLastOutOnly'] ?? false,
    );
  }
}

class Attendance {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String status;
  final String? notes;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.notes,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      date: DateTime.parse(json['date'] as String),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
