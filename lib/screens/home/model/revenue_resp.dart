import 'revenue_chart_data.dart';

class RevenueResp {
  bool status;
  RevenueModel data;
  String message;

  RevenueResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory RevenueResp.fromJson(Map<String, dynamic> json) {
    return RevenueResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? RevenueModel.fromJson(json['data']) : RevenueModel(),
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

class RevenueModel {
  bool status;
  RevenueData data;
  String message;

  RevenueModel({
    this.status = false,
    this.data = const RevenueData(),
    this.message = "",
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? RevenueData.fromJson(json['data']) : RevenueData(),
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

class RevenueData {
  final List<RevenueChartData> yearChartData;
  final List<RevenueChartData> monthChartData;
  final List<RevenueChartData> weekChartData;
  final List<RevenueChartData> dayChartData;

  const RevenueData({
    this.yearChartData = const [],
    this.monthChartData = const [],
    this.weekChartData = const [],
    this.dayChartData = const [],
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      yearChartData: json['year_chart_data'] is List
          ? List<RevenueChartData>.from(json['year_chart_data'].map((x) => RevenueChartData(month: x['label'] ?? '', revenue: (x['value'] as num?)?.toDouble())))
          : [],
      monthChartData: json['month_chart_data'] is List
          ? List<RevenueChartData>.from(json['month_chart_data'].map((x) => RevenueChartData(month: x['label'] ?? '', revenue: (x['value'] as num?)?.toDouble())))
          : [],
      weekChartData: json['week_chart_data'] is List
          ? List<RevenueChartData>.from(json['week_chart_data'].map((x) => RevenueChartData(month: x['label'] ?? '', revenue: (x['value'] as num?)?.toDouble())))
          : [],
      dayChartData: json['day_chart_data'] is List
          ? List<RevenueChartData>.from(json['day_chart_data'].map((x) => RevenueChartData(month: x['label'] ?? '', revenue: (x['value'] as num?)?.toDouble())))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year_chart_data': yearChartData,
      'month_chart_data': monthChartData,
      'week_chart_data': weekChartData,
      'day_chart_data': dayChartData,
    };
  }
}
