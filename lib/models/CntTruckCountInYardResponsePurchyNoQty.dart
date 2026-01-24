class CntTruckCountInYardResponsePurchyNoQty {
  final int success;
  final double total;
  final String selectedDate;
  final String message;

  CntTruckCountInYardResponsePurchyNoQty({
    required this.success,
    required this.total,
    required this.selectedDate,
    required this.message,
  });

  factory CntTruckCountInYardResponsePurchyNoQty.fromJson(Map<String, dynamic> json) {
    return CntTruckCountInYardResponsePurchyNoQty(
      success: json['success'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      selectedDate: json['selectedDate'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
