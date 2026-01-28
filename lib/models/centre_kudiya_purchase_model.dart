class CentreKudiyaPurchaseModel {
  final String code;
  final String name;

  final int dailyCart;
  final int dailyTrolley;
  final int dailyTruck;
  final double dailyWt;

  final int tillCart;
  final int tillTrolley;
  final int tillTruck;
  final double tillWt;

  CentreKudiyaPurchaseModel({
    required this.code,
    required this.name,
    required this.dailyCart,
    required this.dailyTrolley,
    required this.dailyTruck,
    required this.dailyWt,
    required this.tillCart,
    required this.tillTrolley,
    required this.tillTruck,
    required this.tillWt,
  });

  factory CentreKudiyaPurchaseModel.fromJson(Map<String, dynamic> json) {
    return CentreKudiyaPurchaseModel(
      code: json['CN_CODE'].toString(),
      name: json['CN_NAME'] ?? "",

      dailyCart: json['Daily_Cart'] ?? 0,
      dailyTrolley: json['Daily_Trolley'] ?? 0,
      dailyTruck: json['Daily_Truck'] ?? 0,
      dailyWt: (json['Daily_WT'] ?? 0).toDouble(),

      tillCart: json['Till_Cart'] ?? 0,
      tillTrolley: json['Till_Trolley'] ?? 0,
      tillTruck: json['Till_Truck'] ?? 0,
      tillWt: (json['Till_WT'] ?? 0).toDouble(),
    );
  }
}
