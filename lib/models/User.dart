class User {
  final String userId;
  final int userRole;

  User({
    required this.userId,
    required this.userRole,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['USER_ID'].toString(),
      userRole: int.parse(json['USER_ROLE'].toString()), // ✅ KEY FIX
    );
  }
}
