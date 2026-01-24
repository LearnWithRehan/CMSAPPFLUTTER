class CntTruckCountInGrossResponse {
  final int success;
  final int total;
  final String message;

  CntTruckCountInGrossResponse({
    required this.success,
    required this.total,
    required this.message,
  });

  factory CntTruckCountInGrossResponse.fromJson(Map<String, dynamic> json) {
    return CntTruckCountInGrossResponse(
      success: json['success'] ?? 0,
      total: json['total'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
