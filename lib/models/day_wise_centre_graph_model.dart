import 'day_wise_centre_graph_centre_model.dart';

class DayWiseCentreGraphModel {
  final String date;
  final List<DayWiseCentreGraphCentre> centres;

  DayWiseCentreGraphModel({
    required this.date,
    required this.centres,
  });

  factory DayWiseCentreGraphModel.fromJson(
      Map<String, dynamic> json) {
    return DayWiseCentreGraphModel(
      date: json['date'],
      centres: (json['centres'] as List)
          .map((e) =>
          DayWiseCentreGraphCentre.fromJson(e))
          .toList(),
    );
  }
}
