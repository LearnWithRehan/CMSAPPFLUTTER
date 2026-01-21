class PlantModel {
  final String plantCode;
  final String plantName;

  PlantModel({
    required this.plantCode,
    required this.plantName,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantCode: json['plantCode'],
      plantName: json['plantName'],
    );
  }

  @override
  String toString() => plantName;
}
