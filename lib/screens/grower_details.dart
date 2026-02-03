class GrowerDetails {
  final String gName;
  final String gFather;
  final String vName;
  final String gSocCd;
  final String cnCode;
  final String cnName;
  final String gBankAc;

  GrowerDetails({
    required this.gName,
    required this.gFather,
    required this.vName,
    required this.gSocCd,
    required this.cnCode,
    required this.cnName,
    required this.gBankAc,
  });

  factory GrowerDetails.fromJson(Map<String, dynamic> json) {
    return GrowerDetails(
      gName: json['G_NAME'] ?? '',
      gFather: json['G_FATHER'] ?? '',
      vName: json['V_NAME'] ?? '',
      gSocCd: json['G_SOC_CD'] ?? '',
      cnCode: json['CN_CODE'] ?? '',
      cnName: json['CN_NAME'] ?? '',
      gBankAc: json['G_BANKAC'] ?? '',
    );
  }
}
