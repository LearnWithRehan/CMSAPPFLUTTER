class TrolleyCountInYardResponse {
  final int success;
  final int total;
  final String message;

  TrolleyCountInYardResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory TrolleyCountInYardResponse.fromJson(
      Map<String, dynamic> json) {
    return TrolleyCountInYardResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
