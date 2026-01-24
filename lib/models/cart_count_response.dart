class CartCountResponse {
  final int success;
  final int total;
  final String message;

  CartCountResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CartCountResponse.fromJson(Map<String, dynamic> json) {
    return CartCountResponse(
      success: json['success'],
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
