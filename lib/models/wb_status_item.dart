class WbStatusItem {
  final String wbNo;
  final String gStatus;
  final String wFlag;

  WbStatusItem({
    required this.wbNo,
    required this.gStatus,
    required this.wFlag,
  });

  factory WbStatusItem.fromJson(Map<String, dynamic> json) {
    return WbStatusItem(
      wbNo: json['WB_NO'],
      gStatus: json['G_STATUS'],
      wFlag: json['W_FLAG'],
    );
  }
}
