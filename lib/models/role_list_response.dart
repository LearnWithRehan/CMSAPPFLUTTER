import 'role_model.dart';

class RoleListResponse {
  final int success;
  final List<RoleModel> data;
  final String message;

  RoleListResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RoleListResponse.fromJson(Map<String, dynamic> json) {
    return RoleListResponse(
      success: json['success'],
      message: json['message'] ?? "",
      data: (json['data'] as List)
          .map((e) => RoleModel.fromJson(e))
          .toList(),
    );
  }
}
