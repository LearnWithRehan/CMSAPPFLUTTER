class CartCountInYardResponsePurchyNoQty {
  final int success;
  final double total;
  final String message;

  CartCountInYardResponsePurchyNoQty({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CartCountInYardResponsePurchyNoQty.fromJson(
      Map<String, dynamic> json) {
    return CartCountInYardResponsePurchyNoQty(
      success: json['success'] ?? 0,
      total: json['total'] != null
          ? double.parse(json['total'].toString())
          : 0.0,
      message: json['message'] ?? '',
    );
  }
}
