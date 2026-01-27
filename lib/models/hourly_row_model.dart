class HourlyRowModel {
  final String hour;
  final int cartCount;
  final double cartWt;
  final int trolleyCount;
  final double trolleyWt;
  final int truckCount;
  final double truckWt;
  final double total;

  HourlyRowModel({
    required this.hour,
    required this.cartCount,
    required this.cartWt,
    required this.trolleyCount,
    required this.trolleyWt,
    required this.truckCount,
    required this.truckWt,
    required this.total,
  });

  factory HourlyRowModel.fromJson(Map<String, dynamic> json) {
    return HourlyRowModel(
      hour: json["HourSlotLabel"] ?? "",
      cartCount: int.parse(json["Cart_Count"].toString()),
      cartWt: double.parse(json["Cart_wt"].toString()),
      trolleyCount: int.parse(json["Trolley_Count"].toString()),
      trolleyWt: double.parse(json["Trolley_wt"].toString()),
      truckCount: int.parse(json["Truck_Count"].toString()),
      truckWt: double.parse(json["Truck_wt"].toString()),
      total: double.parse(json["TotalNetWeight"].toString()),
    );
  }
}
