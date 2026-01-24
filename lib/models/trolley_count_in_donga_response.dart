class TrolleyCountInDongaResponse {
  final int success;
  final int total;
  final String message;

  TrolleyCountInDongaResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory TrolleyCountInDongaResponse.fromJson(
      Map<String, dynamic> json) {
    return TrolleyCountInDongaResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
