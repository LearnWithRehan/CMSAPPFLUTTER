class UserItem {
  final String userId;

  UserItem({
    required this.userId,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      userId: json['user_id'] ?? "",
    );
  }
}
