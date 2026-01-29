class ScreenMasterModel {
  final String screenId;
  final String screenName;
  bool isChecked;

  ScreenMasterModel({
    required this.screenId,
    required this.screenName,
    this.isChecked = false,
  });

  factory ScreenMasterModel.fromJson(Map<String, dynamic> json) {
    return ScreenMasterModel(
      screenId: json['screenId'].toString(),
      screenName: json['screenName'].toString(),
    );
  }
}
