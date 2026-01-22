import 'cane_day_data.dart';

class CaneTrendResponse {
  final int success;
  final List<CaneDayData> data;

  CaneTrendResponse({required this.success, required this.data});

  factory CaneTrendResponse.fromJson(Map<String, dynamic> json) {
    return CaneTrendResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((e) => CaneDayData.fromJson(e))
          .toList(),
    );
  }
}
