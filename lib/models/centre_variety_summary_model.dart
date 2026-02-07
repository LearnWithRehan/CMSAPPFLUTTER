class CentreVarietyItem {
  final String cnCode;
  final String cnName;

  final double dailyEarly;
  final double dailyGeneral;
  final double dailyReject;
  final double dailyTotal;

  final double tillEarly;
  final double tillGeneral;
  final double tillReject;
  final double tillTotal;

  CentreVarietyItem({
    required this.cnCode,
    required this.cnName,
    required this.dailyEarly,
    required this.dailyGeneral,
    required this.dailyReject,
    required this.dailyTotal,
    required this.tillEarly,
    required this.tillGeneral,
    required this.tillReject,
    required this.tillTotal,
  });

  factory CentreVarietyItem.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) {
        if (v.trim().isEmpty || v == '.00') return 0.0;
        return double.tryParse(v) ?? 0.0;
      }
      return 0.0;
    }

    return CentreVarietyItem(
      cnCode: json['CN_CODE']?.toString() ?? '',
      cnName: json['CN_NAME']?.toString() ?? '',
      dailyEarly: _toDouble(json['Daily_Early_WT']),
      dailyGeneral: _toDouble(json['Daily_General_WT']),
      dailyReject: _toDouble(json['Daily_Reject_WT']),
      dailyTotal: _toDouble(json['Daily_Total_WT']),
      tillEarly: _toDouble(json['Till_Early_WT']),
      tillGeneral: _toDouble(json['Till_General_WT']),
      tillReject: _toDouble(json['Till_Reject_WT']),
      tillTotal: _toDouble(json['Till_Total_WT']),
    );
  }
}
