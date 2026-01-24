class TruckCountInDongaResponse {
  final int success;
  final int total;
  final String message;

  TruckCountInDongaResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory TruckCountInDongaResponse.fromJson(
      Map<String, dynamic> json) {
    return TruckCountInDongaResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
