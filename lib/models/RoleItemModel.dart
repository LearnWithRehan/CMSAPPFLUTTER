class RoleItem {
  final String roleId;
  final String roleName;

  RoleItem({required this.roleId, required this.roleName});

  factory RoleItem.fromJson(Map<String, dynamic> json) {
    return RoleItem(
      roleId: json['role_id'].toString(),
      roleName: json['role_name'] ?? '',
    );
  }

  @override
  String toString() => roleName;
}
