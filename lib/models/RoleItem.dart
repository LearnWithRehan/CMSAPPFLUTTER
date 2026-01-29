class RoleItem {
  final int roleId;
  final String roleName;

  RoleItem({required this.roleId, required this.roleName});

  factory RoleItem.fromJson(Map<String, dynamic> json) {
    return RoleItem(
      roleId: int.parse(json['role_id'].toString()),
      roleName: json['role_name'],
    );
  }

  @override
  String toString() => roleName;
}
