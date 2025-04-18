class HolidayModel {
  final String id;
  final String name;
  final DateTime from;
  final DateTime to;
  final List<UserModel> users;
  final String reason;

  HolidayModel({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.users,
    required this.reason,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      id: json['id'],
      name: json['name'],
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      reason: json['reason'],
      users: (json['users'] as List).map((u) => UserModel.fromJson(u)).toList(),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
