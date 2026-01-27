class CentreModel {
  final String code;
  final String name;

  final int dailyCart;
  final int dailyTrolley;
  final int dailyTruck;
  final double dailyWT;

  final int tillCart;
  final int tillTrolley;
  final int tillTruck;
  final double tillWT;

  CentreModel({
    required this.code,
    required this.name,
    required this.dailyCart,
    required this.dailyTrolley,
    required this.dailyTruck,
    required this.dailyWT,
    required this.tillCart,
    required this.tillTrolley,
    required this.tillTruck,
    required this.tillWT,
  });

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  factory CentreModel.fromJson(Map<String, dynamic> json) {
    return CentreModel(
      code: json['CN_CODE']?.toString() ?? '',
      name: json['CN_NAME']?.toString() ?? '',

      dailyCart: int.tryParse(json['Daily_Cart']?.toString() ?? '0') ?? 0,
      dailyTrolley: int.tryParse(json['Daily_Trolley']?.toString() ?? '0') ?? 0,
      dailyTruck: int.tryParse(json['Daily_Truck']?.toString() ?? '0') ?? 0,
      dailyWT: _toDouble(json['Daily_WT']),

      tillCart: int.tryParse(json['Till_Cart']?.toString() ?? '0') ?? 0,
      tillTrolley: int.tryParse(json['Till_Trolley']?.toString() ?? '0') ?? 0,
      tillTruck: int.tryParse(json['Till_Truck']?.toString() ?? '0') ?? 0,
      tillWT: _toDouble(json['Till_WT']),
    );
  }
}
