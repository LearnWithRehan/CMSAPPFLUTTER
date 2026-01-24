class TruckCountInYardResponsePurchyNoQty {
  final int success;
  final double total;
  final String? selectedDate;
  final String? message;

  TruckCountInYardResponsePurchyNoQty({
    required this.success,
    required this.total,
    this.selectedDate,
    this.message,
  });

  factory TruckCountInYardResponsePurchyNoQty.fromJson(
      Map<String, dynamic> json) {
    return TruckCountInYardResponsePurchyNoQty(
      success: json['success'] ?? 0,
      total: json['total'] != null
          ? (json['total'] as num).toDouble()
          : 0.0,
      selectedDate: json['selectedDate'],
      message: json['message'],
    );
  }
}
