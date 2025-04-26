class OvertimeModel {
  final String id;
  final String from;
  final String to;
  final String type;
  final String? reason;
  final String shift;
  final String status;
  final String? reviewedBy;
  final String? reviewedAt;

  OvertimeModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    this.reason,
    required this.shift,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeModel(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      type: json['type'] as String,
      reason: json['reason'] as String?,
      shift: json['shift'] as String,
      status: json['status'] as String,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
    );
  }
} 