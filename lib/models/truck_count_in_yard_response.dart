class TruckCountInYardResponse {
  final int success;
  final int total;
  final String message;

  TruckCountInYardResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory TruckCountInYardResponse.fromJson(
      Map<String, dynamic> json) {
    return TruckCountInYardResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
