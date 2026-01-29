import 'ScreenPermissionModel.dart';

class SavePermissionRequest {
  final String plantCode;
  final String roleId;
  final List<ScreenPermissionModel> screens;

  SavePermissionRequest(
      this.plantCode,
      this.roleId,
      this.screens,
      );

  Map<String, dynamic> toJson() {
    return {
      "plantCode": plantCode,
      "roleId": roleId,
      "screens": screens.map((e) => e.toJson()).toList(),
    };
  }
}
