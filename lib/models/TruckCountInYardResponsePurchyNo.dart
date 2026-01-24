class TruckCountInYardResponsePurchyNo {
  final int success;
  final int total;
  final String? selectedDate;
  final String? message;

  TruckCountInYardResponsePurchyNo({
    required this.success,
    required this.total,
    this.selectedDate,
    this.message,
  });

  factory TruckCountInYardResponsePurchyNo.fromJson(
      Map<String, dynamic> json) {
    return TruckCountInYardResponsePurchyNo(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      selectedDate: json['selectedDate'],
      message: json['message'],
    );
  }
}
