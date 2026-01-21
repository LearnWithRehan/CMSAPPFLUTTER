import 'User.dart';

class LoginResponse {
  final int success;
  final String message;
  final User user;
  final List<String> permissions;

  LoginResponse({
    required this.success,
    required this.message,
    required this.user,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: int.parse(json['success'].toString()),
      message: json['message'].toString(),
      user: User.fromJson(json['user']),
      permissions:
      List<String>.from(json['permissions'].map((x) => x.toString())),
    );
  }
}
