class PlantModel {
  final String plantCode;
  final String plantName;

  PlantModel({
    required this.plantCode,
    required this.plantName,
  });

  /// Spinner text: Plant Name (101)
  String get displayText => "$plantName ($plantCode)";

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantCode: json['plantCode'].toString(),
      plantName: json['plantName'],
    );
  }
}
