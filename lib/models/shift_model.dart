class ShiftModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String recurrenceRule;
  final List<String> weekDays;
  final String status;
  final BranchModel branch;
  final UserModel user;
  final TimeTableModel timeTable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AttendanceModel> attendance;
  final List<AttendancePermissionModel> attendancePermissions;
  final List<AttendanceOvertimeModel> attendanceOvertime;

  ShiftModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.recurrenceRule,
    required this.weekDays,
    required this.status,
    required this.branch,
    required this.user,
    required this.timeTable,
    required this.createdAt,
    required this.updatedAt,
    List<AttendanceModel>? attendance,
    List<AttendancePermissionModel>? attendancePermissions,
    List<AttendanceOvertimeModel>? attendanceOvertime,
  })  : attendance = attendance ?? [],
        attendancePermissions = attendancePermissions ?? [],
        attendanceOvertime = attendanceOvertime ?? [];

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Shift',
      description: json['description']?.toString() ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'].toString())
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'].toString())
          : null,
      recurrenceRule: json['recurrenceRule']?.toString() ?? 'None',
      weekDays: json['weekDays'] != null
          ? List<String>.from(json['weekDays'].map((e) => e.toString()))
          : [],
      status: json['status']?.toString() ?? 'Active',
      branch: json['branch'] != null
          ? BranchModel.fromJson(json['branch'] as Map<String, dynamic>)
          : BranchModel(
              id: '',
              name: '',
              address: '',
              phone: '',
              status: '',
              qrCode: '',
              openingHours: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : UserModel(
              id: json['userId']?.toString() ?? '',
              name: json['userName']?.toString() ?? 'Unknown User',
              email: json['userEmail']?.toString() ?? '',
            ),
      timeTable: json['timeTable'] != null
          ? TimeTableModel.fromJson(json['timeTable'] as Map<String, dynamic>)
          : TimeTableModel(
              id: json['timeTableId']?.toString() ?? '',
              name: json['timeTableName']?.toString() ?? 'Default Schedule',
              checkInTime: json['checkInTime'] != null
                  ? DateTime.parse(json['checkInTime'].toString())
                  : DateTime.now().copyWith(hour: 9, minute: 0),
              checkOutTime: json['checkOutTime'] != null
                  ? DateTime.parse(json['checkOutTime'].toString())
                  : DateTime.now().copyWith(hour: 17, minute: 0),
              punchFrom: json['punchFrom'] != null
                  ? DateTime.parse(json['punchFrom'].toString())
                  : DateTime.now().copyWith(hour: 8, minute: 30),
              punchTo: json['punchTo'] != null
                  ? DateTime.parse(json['punchTo'].toString())
                  : DateTime.now().copyWith(hour: 17, minute: 30),
              allowLateIn: json['allowLateIn'] as bool? ?? true,
              allowEarlyOut: json['allowEarlyOut'] as bool? ?? true,
              countAbsenceWithoutCheckIn:
                  json['countAbsenceWithoutCheckIn'] as bool? ?? false,
              countAbsenceWithoutCheckOut:
                  json['countAbsenceWithoutCheckOut'] as bool? ?? false,
              useFirstCheckInLastOutOnly:
                  json['useFirstCheckInLastOutOnly'] as bool? ?? false,
              enableOT: json['enableOT'] as bool? ?? false,
              isBreakPaid: json['isBreakPaid'] as bool? ?? false,
              color: json['color']?.toString() ?? '#2196F3',
              lateInThreshold: json['lateInThreshold'] as int? ?? 15,
              lateInAbsenceAfterMinutes:
                  json['lateInAbsenceAfterMinutes'] as int? ?? 30,
              earlyOutThreshold: json['earlyOutThreshold'] as int? ?? 15,
              earlyOutAbsenceAfterMinutes:
                  json['earlyOutAbsenceAfterMinutes'] as int? ?? 30,
              earlyInOTThreshold: json['earlyInOTThreshold'] as int? ?? 0,
              lateOutOTThreshold: json['lateOutOTThreshold'] as int? ?? 0,
              breakStartTime: json['breakStartTime'] != null
                  ? DateTime.parse(json['breakStartTime'].toString())
                  : DateTime.now().copyWith(hour: 12, minute: 0),
              breakEndTime: json['breakEndTime'] != null
                  ? DateTime.parse(json['breakEndTime'].toString())
                  : DateTime.now().copyWith(hour: 13, minute: 0),
              createdAt: json['createdAt'] != null
                  ? DateTime.parse(json['createdAt'].toString())
                  : DateTime.now(),
              updatedAt: json['updatedAt'] != null
                  ? DateTime.parse(json['updatedAt'].toString())
                  : DateTime.now(),
            ),
      attendance: json['attendance'] != null
          ? List<AttendanceModel>.from(
              json['attendance'].map((x) => AttendanceModel.fromJson(x)))
          : [],
      attendancePermissions: json['attendancePermissions'] != null
          ? List<AttendancePermissionModel>.from(json['attendancePermissions']
              .map((x) => AttendancePermissionModel.fromJson(x)))
          : [],
      attendanceOvertime: json['attendanceOvertime'] != null
          ? List<AttendanceOvertimeModel>.from(json['attendanceOvertime']
              .map((x) => AttendanceOvertimeModel.fromJson(x)))
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'recurrenceRule': recurrenceRule,
      'weekDays': weekDays,
      'status': status,
      'branch': branch.toJson(),
      'user': user.toJson(),
      'timeTable': timeTable.toJson(),
      'attendance': attendance.map((x) => x.toJson()).toList(),
      'attendancePermissions':
          attendancePermissions.map((x) => x.toJson()).toList(),
      'attendanceOvertime': attendanceOvertime.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ShiftModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? recurrenceRule,
    List<String>? weekDays,
    String? status,
    BranchModel? branch,
    UserModel? user,
    TimeTableModel? timeTable,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AttendanceModel>? attendance,
    List<AttendancePermissionModel>? attendancePermissions,
    List<AttendanceOvertimeModel>? attendanceOvertime,
  }) {
    return ShiftModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      weekDays: weekDays ?? this.weekDays,
      status: status ?? this.status,
      branch: branch ?? this.branch,
      user: user ?? this.user,
      timeTable: timeTable ?? this.timeTable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attendance: attendance ?? this.attendance,
      attendancePermissions:
          attendancePermissions ?? this.attendancePermissions,
      attendanceOvertime: attendanceOvertime ?? this.attendanceOvertime,
    );
  }
}

class BranchModel {
  final String id;
  final String name;
  final String address;
  final double? branchLat;
  final double? branchLng;
  final String phone;
  final String status;
  final String qrCode;
  final List<OpeningHourModel> openingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    this.branchLat,
    this.branchLng,
    required this.phone,
    required this.status,
    required this.qrCode,
    required this.openingHours,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      branchLat: json['branchLat'] != null
          ? (json['branchLat'] is int
              ? (json['branchLat'] as int).toDouble()
              : json['branchLat'] as double)
          : null,
      branchLng: json['branchLng'] != null
          ? (json['branchLng'] is int
              ? (json['branchLng'] as int).toDouble()
              : json['branchLng'] as double)
          : null,
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      qrCode: json['QRCode']?.toString() ?? '',
      openingHours: _parseOpeningHours(json['openingHours']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  static List<OpeningHourModel> _parseOpeningHours(dynamic openingHoursData) {
    if (openingHoursData == null) return [];

    // If it's already a List, parse it as before
    if (openingHoursData is List) {
      return openingHoursData
          .map((e) => OpeningHourModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // If it's a Map (new format), convert it to List of OpeningHourModel
    if (openingHoursData is Map<String, dynamic>) {
      return openingHoursData.entries.map((entry) {
        final dayName = entry.key;
        final dayData = entry.value as Map<String, dynamic>?;

        if (dayData != null) {
          return OpeningHourModel(
            name: dayName,
            workingHours: [
              {
                'open': dayData['open']?.toString() ?? '',
                'close': dayData['close']?.toString() ?? '',
              }
            ],
          );
        }

        return OpeningHourModel(
          name: dayName,
          workingHours: [],
        );
      }).toList();
    }

    return [];
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
      'QRCode': qrCode,
      'openingHours': openingHours.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class OpeningHourModel {
  final String name;
  final List<dynamic> workingHours;

  OpeningHourModel({
    required this.name,
    required this.workingHours,
  });

  factory OpeningHourModel.fromJson(Map<String, dynamic> json) {
    return OpeningHourModel(
      name: json['name']?.toString() ?? '',
      workingHours: json['workingHours'] as List? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'workingHours': workingHours,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class TimeTableModel {
  final String id;
  final String name;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final DateTime punchFrom;
  final DateTime punchTo;
  final bool allowLateIn;
  final bool allowEarlyOut;
  final bool countAbsenceWithoutCheckIn;
  final bool countAbsenceWithoutCheckOut;
  final bool useFirstCheckInLastOutOnly;
  final bool enableOT;
  final bool isBreakPaid;
  final String color;
  final int lateInThreshold;
  final int lateInAbsenceAfterMinutes;
  final int earlyOutThreshold;
  final int earlyOutAbsenceAfterMinutes;
  final int earlyInOTThreshold;
  final int lateOutOTThreshold;
  final DateTime breakStartTime;
  final DateTime breakEndTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeTableModel({
    required this.id,
    required this.name,
    required this.checkInTime,
    required this.checkOutTime,
    required this.punchFrom,
    required this.punchTo,
    required this.allowLateIn,
    required this.allowEarlyOut,
    required this.countAbsenceWithoutCheckIn,
    required this.countAbsenceWithoutCheckOut,
    required this.useFirstCheckInLastOutOnly,
    required this.enableOT,
    required this.isBreakPaid,
    required this.color,
    required this.lateInThreshold,
    required this.lateInAbsenceAfterMinutes,
    required this.earlyOutThreshold,
    required this.earlyOutAbsenceAfterMinutes,
    required this.earlyInOTThreshold,
    required this.lateOutOTThreshold,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    // Helper function to parse time string to DateTime
    DateTime parseTimeString(String? timeStr) {
      if (timeStr == null) return DateTime.now();
      try {
        // Try parsing as ISO8601 first
        return DateTime.parse(timeStr);
      } catch (e) {
        // If that fails, try parsing as HH:mm
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, int.parse(parts[0]),
              int.parse(parts[1]));
        }
        return DateTime.now();
      }
    }

    return TimeTableModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      checkInTime: parseTimeString(json['checkInTime']?.toString()),
      checkOutTime: parseTimeString(json['checkOutTime']?.toString()),
      punchFrom: parseTimeString(json['punchFrom']?.toString()),
      punchTo: parseTimeString(json['punchTo']?.toString()),
      allowLateIn: json['allowLateIn'] as bool? ?? false,
      allowEarlyOut: json['allowEarlyOut'] as bool? ?? false,
      countAbsenceWithoutCheckIn:
          json['countAbsenceWithoutCheckIn'] as bool? ?? false,
      countAbsenceWithoutCheckOut:
          json['countAbsenceWithoutCheckOut'] as bool? ?? false,
      useFirstCheckInLastOutOnly:
          json['useFirstCheckInLastOutOnly'] as bool? ?? false,
      enableOT: json['enableOT'] as bool? ?? false,
      isBreakPaid: json['isBreakPaid'] as bool? ?? false,
      color: json['color']?.toString() ?? '',
      lateInThreshold: json['lateInThreshold'] as int? ?? 0,
      lateInAbsenceAfterMinutes: json['lateInAbsenceAfterMinutes'] as int? ?? 0,
      earlyOutThreshold: json['earlyOutThreshold'] as int? ?? 0,
      earlyOutAbsenceAfterMinutes:
          json['earlyOutAbsenceAfterMinutes'] as int? ?? 0,
      earlyInOTThreshold: json['earlyInOTThreshold'] as int? ?? 0,
      lateOutOTThreshold: json['lateOutOTThreshold'] as int? ?? 0,
      breakStartTime: parseTimeString(json['breakStartTime']?.toString()),
      breakEndTime: parseTimeString(json['breakEndTime']?.toString()),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime.toIso8601String(),
      'punchFrom': punchFrom.toIso8601String(),
      'punchTo': punchTo.toIso8601String(),
      'allowLateIn': allowLateIn,
      'allowEarlyOut': allowEarlyOut,
      'countAbsenceWithoutCheckIn': countAbsenceWithoutCheckIn,
      'countAbsenceWithoutCheckOut': countAbsenceWithoutCheckOut,
      'useFirstCheckInLastOutOnly': useFirstCheckInLastOutOnly,
      'enableOT': enableOT,
      'isBreakPaid': isBreakPaid,
      'color': color,
      'lateInThreshold': lateInThreshold,
      'lateInAbsenceAfterMinutes': lateInAbsenceAfterMinutes,
      'earlyOutThreshold': earlyOutThreshold,
      'earlyOutAbsenceAfterMinutes': earlyOutAbsenceAfterMinutes,
      'earlyInOTThreshold': earlyInOTThreshold,
      'lateOutOTThreshold': lateOutOTThreshold,
      'breakStartTime': breakStartTime.toIso8601String(),
      'breakEndTime': breakEndTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AttendanceModel {
  final String id;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final UserModel? doneInBy;
  final UserModel? doneOutBy;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final bool automatic;

  AttendanceModel({
    required this.id,
    this.checkInDate,
    this.checkOutDate,
    this.doneInBy,
    this.doneOutBy,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    required this.automatic,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id']?.toString() ?? '',
      checkInDate: json['checkInDate'] != null
          ? DateTime.parse(json['checkInDate'].toString())
          : null,
      checkOutDate: json['checkOutDate'] != null
          ? DateTime.parse(json['checkOutDate'].toString())
          : null,
      doneInBy: json['doneInBy'] != null
          ? UserModel.fromJson(json['doneInBy'] as Map<String, dynamic>)
          : null,
      doneOutBy: json['doneOutBy'] != null
          ? UserModel.fromJson(json['doneOutBy'] as Map<String, dynamic>)
          : null,
      checkInLat: json['checkInLat']?.toDouble(),
      checkInLng: json['checkInLng']?.toDouble(),
      checkOutLat: json['checkOutLat']?.toDouble(),
      checkOutLng: json['checkOutLng']?.toDouble(),
      automatic: json['automatic'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkInDate': checkInDate?.toIso8601String(),
      'checkOutDate': checkOutDate?.toIso8601String(),
      'doneInBy': doneInBy?.toJson(),
      'doneOutBy': doneOutBy?.toJson(),
      'checkInLat': checkInLat,
      'checkInLng': checkInLng,
      'checkOutLat': checkOutLat,
      'checkOutLng': checkOutLng,
      'automatic': automatic,
    };
  }
}

class AttendancePermissionModel {
  final String id;
  final String type;
  final int duration;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendancePermissionModel({
    required this.id,
    required this.type,
    required this.duration,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendancePermissionModel.fromJson(Map<String, dynamic> json) {
    return AttendancePermissionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      duration: json['duration'] as int? ?? 0,
      reason: json['reason']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AttendanceOvertimeModel {
  final String id;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceOvertimeModel({
    required this.id,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceOvertimeModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOvertimeModel(
      id: json['id']?.toString() ?? '',
      duration: json['duration'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
