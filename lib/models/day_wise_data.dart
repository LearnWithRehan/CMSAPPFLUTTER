import 'centre_data.dart';

class DayWiseData {
  final String date;
  final List<CentreData> centres;

  DayWiseData({
    required this.date,
    required this.centres,
  });

  factory DayWiseData.fromJson(Map<String, dynamic> json) {
    return DayWiseData(
      date: json['date'],
      centres: (json['centres'] as List)
          .map((e) => CentreData.fromJson(e))
          .toList(),
    );
  }
}
