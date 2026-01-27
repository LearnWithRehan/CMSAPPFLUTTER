import 'centre_model.dart';

class CentreResponse {
  final int success;
  final List<CentreModel> centres;

  CentreResponse({
    required this.success,
    required this.centres,
  });

  factory CentreResponse.fromJson(Map<String, dynamic> json) {
    return CentreResponse(
      success: json['success'] ?? 0,
      centres: (json['centres'] as List? ?? [])
          .map((e) => CentreModel.fromJson(e))
          .toList(),
    );
  }
}
