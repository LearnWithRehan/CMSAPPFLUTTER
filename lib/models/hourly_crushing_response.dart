class HourlyCrushingResponse {
  final int success;
  final List<HourlyCrushingRow> data;

  HourlyCrushingResponse({
    required this.success,
    required this.data,
  });

  factory HourlyCrushingResponse.fromJson(Map<String, dynamic> json) {
    return HourlyCrushingResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((e) => HourlyCrushingRow.fromJson(e))
          .toList(),
    );
  }
}

class HourlyCrushingRow {
  final String hour;
  final int cartCount;
  final double cartWt;
  final int trolleyCount;
  final double trolleyWt;
  final int truckCount;
  final double truckWt;
  final double totalWt;

  HourlyCrushingRow({
    required this.hour,
    required this.cartCount,
    required this.cartWt,
    required this.trolleyCount,
    required this.trolleyWt,
    required this.truckCount,
    required this.truckWt,
    required this.totalWt,
  });

  factory HourlyCrushingRow.fromJson(Map<String, dynamic> json) {
    return HourlyCrushingRow(
      hour: json['HourSlotLabel'],
      cartCount: json['Cart_Count'],
      cartWt: (json['Cart_wt'] ?? 0).toDouble(),
      trolleyCount: json['Trolley_Count'],
      trolleyWt: (json['Trolley_wt'] ?? 0).toDouble(),
      truckCount: json['Truck_Count'],
      truckWt: (json['Truck_wt'] ?? 0).toDouble(),
      totalWt: (json['TotalNetWeight'] ?? 0).toDouble(),
    );
  }
}
