class LoginResponse {
  final int success;
  final String message;
  final UserModel? user;
  final List<String> permissions;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
    );
  }
}

class UserModel {
  final String userId;
  final int userRole;

  UserModel({
    required this.userId,
    required this.userRole,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['USER_ID'],
      userRole: json['USER_ROLE'],
    );
  }
}
