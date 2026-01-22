class CentreData {
  final String centreName;
  final double totalCane;

  CentreData({
    required this.centreName,
    required this.totalCane,
  });

  factory CentreData.fromJson(Map<String, dynamic> json) {
    return CentreData(
      centreName: json['centreName'],
      totalCane: (json['totalCane'] as num).toDouble(),
    );
  }
}
