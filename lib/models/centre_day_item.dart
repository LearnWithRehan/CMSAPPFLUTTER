class CentreDayItem {
  final String reportDate;
  final String cnCode;
  final String cnName;
  final double early;
  final double general;
  final double reject;
  final double total;

  CentreDayItem({
    required this.reportDate,
    required this.cnCode,
    required this.cnName,
    required this.early,
    required this.general,
    required this.reject,
    required this.total,
  });

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  factory CentreDayItem.fromJson(Map<String, dynamic> json) {
    return CentreDayItem(
      reportDate: json['report_date'] ?? "",
      cnCode: json['CN_CODE'].toString(),
      cnName: json['CN_NAME'] ?? "",
      early: _toDouble(json['Daily_Early_WT']),
      general: _toDouble(json['Daily_General_WT']),
      reject: _toDouble(json['Daily_Reject_WT']),
      total: _toDouble(json['Daily_Total_WT']),
    );
  }
}
