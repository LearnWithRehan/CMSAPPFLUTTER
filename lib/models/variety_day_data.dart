class VarietyDayData {
  final String date;
  final double early;
  final double general;
  final double reject;

  VarietyDayData({
    required this.date,
    required this.early,
    required this.general,
    required this.reject,
  });

  factory VarietyDayData.fromJson(Map<String, dynamic> json) {
    return VarietyDayData(
      date: json['date'],
      early: double.parse(json['early'].toString()),
      general: double.parse(json['general'].toString()),
      reject: double.parse(json['reject'].toString()),
    );
  }
}
