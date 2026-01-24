class TrolleyCountPurchyResponse {
  final int success;
  final int total;
  final String message;
  final String? selectedDate;

  TrolleyCountPurchyResponse({
    required this.success,
    required this.total,
    required this.message,
    this.selectedDate,
  });

  factory TrolleyCountPurchyResponse.fromJson(
      Map<String, dynamic> json) {
    return TrolleyCountPurchyResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
      selectedDate: json['selectedDate'],
    );
  }
}
