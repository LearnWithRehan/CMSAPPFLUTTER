class CntTruckCountInYardResponsePurchyNo {
  final int success;
  final int total;
  final String selectedDate;
  final String message;

  CntTruckCountInYardResponsePurchyNo({
    required this.success,
    required this.total,
    required this.selectedDate,
    required this.message,
  });

  factory CntTruckCountInYardResponsePurchyNo.fromJson(Map<String, dynamic> json) {
    return CntTruckCountInYardResponsePurchyNo(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      selectedDate: json['selectedDate'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
