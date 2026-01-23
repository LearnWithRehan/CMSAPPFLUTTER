class CentreWiseTotalCaneModel {
  final String centreName;
  final double totalCane;

  CentreWiseTotalCaneModel({
    required this.centreName,
    required this.totalCane,
  });

  factory CentreWiseTotalCaneModel.fromJson(Map<String, dynamic> json) {
    return CentreWiseTotalCaneModel(
      centreName: json['centreName'],
      totalCane: (json['totalCane'] as num).toDouble(),
    );
  }
}
