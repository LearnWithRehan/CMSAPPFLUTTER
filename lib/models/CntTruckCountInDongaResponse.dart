class CntTruckCountInDongaResponse {
  final int success;
  final int total;
  final String message;

  CntTruckCountInDongaResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CntTruckCountInDongaResponse.fromJson(Map<String, dynamic> json) {
    return CntTruckCountInDongaResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
