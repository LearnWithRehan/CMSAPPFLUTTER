class VillageWiseItem {
  final String vCode;
  final String vName;

  final int dayCart;
  final int dayTrolley;
  final int dayTruck;
  final double dayWeight;

  final int toCart;
  final int toTrolley;
  final int toTruck;
  final double toWeight;

  VillageWiseItem({
    required this.vCode,
    required this.vName,
    required this.dayCart,
    required this.dayTrolley,
    required this.dayTruck,
    required this.dayWeight,
    required this.toCart,
    required this.toTrolley,
    required this.toTruck,
    required this.toWeight,
  });

  factory VillageWiseItem.fromJson(Map<String, dynamic> json) {
    return VillageWiseItem(
      vCode: json['V_CODE'].toString(),
      vName: json['V_NAME'] ?? '',

      dayCart: json['DAY_CART'] ?? 0,
      dayTrolley: json['DAY_TROLLEY'] ?? 0,
      dayTruck: json['DAY_TRUCK'] ?? 0,
      dayWeight: (json['DAY_WEIGHT'] ?? 0).toDouble(),

      toCart: json['TODATE_CART'] ?? 0,
      toTrolley: json['TODATE_TROLLEY'] ?? 0,
      toTruck: json['TODATE_TRUCK'] ?? 0,
      toWeight: (json['TODATE_WEIGHT'] ?? 0).toDouble(),
    );
  }
}
