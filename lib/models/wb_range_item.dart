class WbRangeItem {
  String wMaxWt;
  String wAdjWt;

  WbRangeItem({
    required this.wMaxWt,
    required this.wAdjWt,
  });

  factory WbRangeItem.fromJson(Map<String, dynamic> json) {
    return WbRangeItem(
      wMaxWt: json['W_MAXWT']?.toString() ?? '',
      wAdjWt: json['W_ADJWT']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "W_MAXWT": wMaxWt,
      "W_ADJWT": wAdjWt,
    };
  }
}
