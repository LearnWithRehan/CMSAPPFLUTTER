class CartCountDongaResponse {
  final int success;
  final int total;
  final String message;

  CartCountDongaResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CartCountDongaResponse.fromJson(Map<String, dynamic> json) {
    return CartCountDongaResponse(
      success: json['success'],
      total: json['total'],
      message: json['message'],
    );
  }
}
