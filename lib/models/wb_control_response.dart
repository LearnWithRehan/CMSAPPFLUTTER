class WbControlData {
  final String gStatus;
  final String wFlag;

  WbControlData({required this.gStatus, required this.wFlag});

  factory WbControlData.fromJson(Map<String, dynamic> json) {
    return WbControlData(
      gStatus: json['G_STATUS'],
      wFlag: json['W_FLAG'],
    );
  }
}
