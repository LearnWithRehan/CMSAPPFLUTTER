class CentrePurchaseModel {
  final String code;
  final String name;
  final double dailyWt;
  final double tillWt;

  CentrePurchaseModel({
    required this.code,
    required this.name,
    required this.dailyWt,
    required this.tillWt,
  });

  factory CentrePurchaseModel.fromJson(Map<String, dynamic> json) {
    return CentrePurchaseModel(
      code: json['CN_CODE'].toString(),
      name: json['CN_NAME'] ?? '',
      dailyWt: double.tryParse(json['Daily_WT'].toString()) ?? 0,
      tillWt: double.tryParse(json['Till_WT'].toString()) ?? 0,
    );
  }
}
