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
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
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
              id: '',
              name: '',
              email: '',
            ),
      timeTable: json['timeTable'] != null
          ? TimeTableModel.fromJson(json['timeTable'] as Map<String, dynamic>)
          : TimeTableModel(
              id: '',
              name: '',
              checkInTime: DateTime.now(),
              checkOutTime: DateTime.now(),
              punchFrom: DateTime.now(),
              punchTo: DateTime.now(),
              allowLateIn: false,
              allowEarlyOut: false,
              countAbsenceWithoutCheckIn: false,
              countAbsenceWithoutCheckOut: false,
              useFirstCheckInLastOutOnly: false,
              enableOT: false,
              isBreakPaid: false,
              color: '',
              lateInThreshold: 0,
              lateInAbsenceAfterMinutes: 0,
              earlyOutThreshold: 0,
              earlyOutAbsenceAfterMinutes: 0,
              earlyInOTThreshold: 0,
              lateOutOTThreshold: 0,
              breakStartTime: DateTime.now(),
              breakEndTime: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
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
      openingHours: (json['openingHours'] as List?)
              ?.map((e) => OpeningHourModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
          return DateTime(now.year, now.month, now.day, 
            int.parse(parts[0]), int.parse(parts[1]));
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
      countAbsenceWithoutCheckIn: json['countAbsenceWithoutCheckIn'] as bool? ?? false,
      countAbsenceWithoutCheckOut: json['countAbsenceWithoutCheckOut'] as bool? ?? false,
      useFirstCheckInLastOutOnly: json['useFirstCheckInLastOutOnly'] as bool? ?? false,
      enableOT: json['enableOT'] as bool? ?? false,
      isBreakPaid: json['isBreakPaid'] as bool? ?? false,
      color: json['color']?.toString() ?? '',
      lateInThreshold: json['lateInThreshold'] as int? ?? 0,
      lateInAbsenceAfterMinutes: json['lateInAbsenceAfterMinutes'] as int? ?? 0,
      earlyOutThreshold: json['earlyOutThreshold'] as int? ?? 0,
      earlyOutAbsenceAfterMinutes: json['earlyOutAbsenceAfterMinutes'] as int? ?? 0,
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
