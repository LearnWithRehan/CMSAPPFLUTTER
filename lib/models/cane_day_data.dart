class CaneDayData {
  final String date;
  final double totalCane;

  CaneDayData({
    required this.date,
    required this.totalCane,
  });

  factory CaneDayData.fromJson(Map<String, dynamic> json) {
    return CaneDayData(
      date: json['date'],
      totalCane: (json['totalCane'] as num).toDouble(),
    );
  }
}
