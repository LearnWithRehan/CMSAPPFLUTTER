class ModeCountItem {
  final String centre;
  final String mode;
  final String totalCount;
  final String totalWt;

  ModeCountItem({
    required this.centre,
    required this.mode,
    required this.totalCount,
    required this.totalWt,
  });

  factory ModeCountItem.fromJson(Map<String, dynamic> json) {
    return ModeCountItem(
      centre: json['G_CNT_CD'] ?? '',
      mode: json['G_MODE'] ?? '',
      totalCount: json['TotalCount']?.toString() ?? '0',
      totalWt: json['TotalWt']?.toString() ?? '0',
    );
  }
}
