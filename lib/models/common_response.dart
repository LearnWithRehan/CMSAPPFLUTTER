class CommonResponse {
  final int success;
  final String message;

  CommonResponse({
    required this.success,
    required this.message,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
