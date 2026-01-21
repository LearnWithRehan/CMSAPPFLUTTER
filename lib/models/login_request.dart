class LoginRequest {
  final String userId;
  final String password;
  final String plantCode;

  LoginRequest({
    required this.userId,
    required this.password,
    required this.plantCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "User_Id": userId,
      "Password": password,
      "PlantCode": plantCode,
    };
  }
}
