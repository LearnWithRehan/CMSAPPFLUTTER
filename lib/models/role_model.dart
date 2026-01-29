class RoleModel {
  final String roleId;
  final String roleName;

  RoleModel({
    required this.roleId,
    required this.roleName,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      roleId: json['ROLE_ID'].toString(),
      roleName: json['ROLE_NAME'].toString(),
    );
  }
}
