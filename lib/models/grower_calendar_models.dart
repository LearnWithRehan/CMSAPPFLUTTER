class GrowerCalendarResponse {
  final int success;
  final GrowerCalendarData? data;
  final String message;

  GrowerCalendarResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory GrowerCalendarResponse.fromJson(Map<String, dynamic> json) {
    return GrowerCalendarResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? GrowerCalendarData.fromJson(json['data'])
          : null,
    );
  }
}

class GrowerCalendarData {
  final double areaR;
  final double areaP;

  final int yieldR;
  final int yieldP;

  final int purchyR;
  final int purchyP;

  final int issueR;
  final int issueP;

  GrowerCalendarData({
    required this.areaR,
    required this.areaP,
    required this.yieldR,
    required this.yieldP,
    required this.purchyR,
    required this.purchyP,
    required this.issueR,
    required this.issueP,
  });

  factory GrowerCalendarData.fromJson(Map<String, dynamic> json) {
    return GrowerCalendarData(
      areaR: double.tryParse(json['G_AR_GNR'].toString()) ?? 0,
      areaP: double.tryParse(json['G_AR_GNP'].toString()) ?? 0,

      yieldR: int.tryParse(json['VAR_31_COUNT'].toString()) ?? 0,
      yieldP: int.tryParse(json['VAR_33_COUNT'].toString()) ?? 0,

      issueR: int.tryParse(json['VAR_31_STATUS1_COUNT'].toString()) ?? 0,
      issueP: int.tryParse(json['VAR_33_STATUS1_COUNT'].toString()) ?? 0,

      purchyR: int.tryParse(json['G_T_RAT'].toString()) ?? 0,
      purchyP: int.tryParse(json['G_T_PL'].toString()) ?? 0,
    );
  }
}
