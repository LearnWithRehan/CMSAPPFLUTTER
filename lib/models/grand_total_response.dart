class GrandTotalResponse {
  final int success;
  final double grandTotal;
  final String selectedDate;
  final String message;

  GrandTotalResponse({
    required this.success,
    required this.grandTotal,
    required this.selectedDate,
    required this.message,
  });

  factory GrandTotalResponse.fromJson(Map<String, dynamic> json) {
    return GrandTotalResponse(
      success: json['success'] ?? 0,
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      selectedDate: json['selectedDate'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
