class CartCountPurchyResponse {
  final int success;
  final int total;
  final String message;

  CartCountPurchyResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CartCountPurchyResponse.fromJson(Map<String, dynamic> json) {
    return CartCountPurchyResponse(
      success: json['success'],
      total: json['total'],
      message: json['message'],
    );
  }
}
