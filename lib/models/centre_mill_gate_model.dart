class CentreMillGateModel {
  final String code;
  final String name;

  final double purDaily;
  final double recDaily;
  final double dailyTotal;

  final double purTill;
  final double recTill;
  final double tillTotal;

  CentreMillGateModel({
    required this.code,
    required this.name,
    required this.purDaily,
    required this.recDaily,
    required this.dailyTotal,
    required this.purTill,
    required this.recTill,
    required this.tillTotal,
  });

  factory CentreMillGateModel.fromJson(Map<String, dynamic> json) {
    double _d(v) => double.tryParse(v.toString()) ?? 0;

    return CentreMillGateModel(
      code: json["CN_CODE"].toString(),
      name: json["CN_NAME"].toString(),
      purDaily: _d(json["PurDaily_WT"]),
      recDaily: _d(json["RecDaily_WT"]),
      dailyTotal: _d(json["DailyTotal_WT"]),
      purTill: _d(json["PurTill_WT"]),
      recTill: _d(json["RecTill_WT"]),
      tillTotal: _d(json["TillTotal_WT"]),
    );
  }
}
