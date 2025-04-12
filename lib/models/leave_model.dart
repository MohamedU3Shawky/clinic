import 'package:intl/intl.dart';

class LeaveSettingModel {
  final String id;
  final String name;
  final int defaultDays;
  final bool isPaid;
  final bool isEnabled;
  final List<CustomPolicyModel> customPolicies;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveSettingModel({
    required this.id,
    required this.name,
    required this.defaultDays,
    required this.isPaid,
    required this.isEnabled,
    required this.customPolicies,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveSettingModel.fromJson(Map<String, dynamic> json) {
    return LeaveSettingModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      defaultDays: json['defaultDays'] as int? ?? 0,
      isPaid: json['isPaid'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
      customPolicies: (json['customPolicies'] as List?)
              ?.map(
                  (e) => CustomPolicyModel.fromJson(e as Map<String, dynamic>))
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
      'defaultDays': defaultDays,
      'isPaid': isPaid,
      'isEnabled': isEnabled,
      'customPolicies': customPolicies.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LeaveSettingModel copyWith({
    String? id,
    String? name,
    int? defaultDays,
    bool? isPaid,
    bool? isEnabled,
    List<CustomPolicyModel>? customPolicies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveSettingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultDays: defaultDays ?? this.defaultDays,
      isPaid: isPaid ?? this.isPaid,
      isEnabled: isEnabled ?? this.isEnabled,
      customPolicies: customPolicies ?? this.customPolicies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CustomPolicyModel {
  final String id;
  final String name;
  final List<UserModel> users;
  final int noOfDays;
  final LeaveSettingReferenceModel leaveSetting;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomPolicyModel({
    required this.id,
    required this.name,
    required this.users,
    required this.noOfDays,
    required this.leaveSetting,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomPolicyModel.fromJson(Map<String, dynamic> json) {
    return CustomPolicyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      users: (json['users'] as List?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      noOfDays: json['noOfDays'] as int? ?? 0,
      leaveSetting: json['leaveSetting'] != null
          ? LeaveSettingReferenceModel.fromJson(
              json['leaveSetting'] as Map<String, dynamic>)
          : LeaveSettingReferenceModel(id: '', name: ''),
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
      'users': users.map((e) => e.toJson()).toList(),
      'noOfDays': noOfDays,
      'leaveSetting': leaveSetting.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class LeaveSettingReferenceModel {
  final String id;
  final String name;

  LeaveSettingReferenceModel({
    required this.id,
    required this.name,
  });

  factory LeaveSettingReferenceModel.fromJson(Map<String, dynamic> json) {
    return LeaveSettingReferenceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final RoleModel? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role?.toJson(),
    };
  }
}

class RoleModel {
  final String id;
  final String name;

  RoleModel({
    required this.id,
    required this.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LeaveModel {
  final String id;
  final DateTime from;
  final DateTime to;
  final String status;
  final UserModel user;
  final UserModel? reviewedBy;
  final LeaveSettingReferenceModel? leaveSetting;
  final String reason;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String leaveSettingId;

  LeaveModel({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
    required this.user,
    this.reviewedBy,
    this.leaveSetting,
    required this.reason,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.leaveSettingId,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id']?.toString() ?? '',
      from: json['from'] != null
          ? DateTime.parse(json['from'].toString())
          : DateTime.now(),
      to: json['to'] != null
          ? DateTime.parse(json['to'].toString())
          : DateTime.now(),
      status: json['status']?.toString() ?? 'Pending',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : UserModel(id: '', name: '', email: ''),
      reviewedBy: json['reviewedBy'] != null
          ? UserModel.fromJson(json['reviewedBy'] as Map<String, dynamic>)
          : null,
      leaveSetting: json['leaveSetting'] != null
          ? LeaveSettingReferenceModel.fromJson(
              json['leaveSetting'] as Map<String, dynamic>)
          : null,
      reason: json['reason']?.toString() ?? '',
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
      leaveSettingId: json['leaveSettingId']?.toString() ??
          json['leaveSetting']?['id']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'status': status,
      'user': user.toJson(),
      'reviewedBy': reviewedBy?.toJson(),
      'leaveSetting': leaveSetting?.toJson(),
      'reason': reason,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'leaveSettingId': leaveSettingId,
    };
  }

  LeaveModel copyWith({
    String? id,
    DateTime? from,
    DateTime? to,
    String? status,
    UserModel? user,
    UserModel? reviewedBy,
    LeaveSettingReferenceModel? leaveSetting,
    String? reason,
    DateTime? reviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? leaveSettingId,
  }) {
    return LeaveModel(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      status: status ?? this.status,
      user: user ?? this.user,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      leaveSetting: leaveSetting ?? this.leaveSetting,
      reason: reason ?? this.reason,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      leaveSettingId: leaveSettingId ?? this.leaveSettingId,
    );
  }

  String get formattedDateRange {
    final dateFormat = DateFormat('MMM d, yyyy');
    return '${dateFormat.format(from)} - ${dateFormat.format(to)}';
  }

  bool get canUpdate => status == 'Pending';
  bool get canDelete => status == 'Pending';
}

class LeaveResponseModel {
  final List<LeaveModel> leaves;
  final int leavesCount;
  final int approvedLeavesCount;
  final int pendingLeavesCount;
  final int rejectedLeavesCount;

  LeaveResponseModel({
    required this.leaves,
    required this.leavesCount,
    required this.approvedLeavesCount,
    required this.pendingLeavesCount,
    required this.rejectedLeavesCount,
  });

  factory LeaveResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LeaveResponseModel(
      leaves: (data['data'] as List?)
              ?.map((e) => LeaveModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      leavesCount: data['leavesCount'] as int? ?? 0,
      approvedLeavesCount: data['approvedLeavesCount'] as int? ?? 0,
      pendingLeavesCount: data['pendingLeavesCount'] as int? ?? 0,
      rejectedLeavesCount: data['rejectedLeavesCount'] as int? ?? 0,
    );
  }
}
