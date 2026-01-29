class NextRoleIdResponse {
  final int success;
  final int nextRoleId;
  final String message;

  NextRoleIdResponse({
    required this.success,
    required this.nextRoleId,
    required this.message,
  });

  factory NextRoleIdResponse.fromJson(Map<String, dynamic> json) {
    return NextRoleIdResponse(
      success: json['success'],
      nextRoleId: json['next_role_id'],
      message: json['message'] ?? "",
    );
  }
}
