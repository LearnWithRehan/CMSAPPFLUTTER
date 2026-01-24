class TrolleyCountPurchyQtyResponse {
  final int success;
  final double total;
  final String message;
  final String? selectedDate;

  TrolleyCountPurchyQtyResponse({
    required this.success,
    required this.total,
    required this.message,
    this.selectedDate,
  });

  factory TrolleyCountPurchyQtyResponse.fromJson(
      Map<String, dynamic> json) {
    return TrolleyCountPurchyQtyResponse(
      success: json['success'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      message: json['message'] ?? '',
      selectedDate: json['selectedDate'],
    );
  }
}
