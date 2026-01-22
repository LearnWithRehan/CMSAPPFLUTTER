class DayWiseCentreGraphCentre {
  final String centreName;
  final double totalCane;

  DayWiseCentreGraphCentre({
    required this.centreName,
    required this.totalCane,
  });

  factory DayWiseCentreGraphCentre.fromJson(
      Map<String, dynamic> json) {
    return DayWiseCentreGraphCentre(
      centreName: json['centreName'],
      totalCane: (json['totalCane'] as num).toDouble(),
    );
  }
}
