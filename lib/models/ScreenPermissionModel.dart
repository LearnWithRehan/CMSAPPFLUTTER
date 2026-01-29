class ScreenPermissionModel {
  final String screenId;
  final String screenName;

  ScreenPermissionModel(this.screenId, this.screenName);

  Map<String, dynamic> toJson() {
    return {
      "screenId": screenId,
      "screenName": screenName,
    };
  }
}
