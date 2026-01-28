class ContractorReceiptModel {
  final String gatePass;
  final String truckNo;
  final String date;
  final String netWt;
  final String purWt;
  final String diff;

  ContractorReceiptModel({
    required this.gatePass,
    required this.truckNo,
    required this.date,
    required this.netWt,
    required this.purWt,
    required this.diff,
  });

  factory ContractorReceiptModel.fromJson(Map<String, dynamic> json) {
    return ContractorReceiptModel(
      gatePass: json['gate_pass'] ?? '',
      truckNo: json['truck_no'] ?? '',
      date: json['date'] ?? '',
      netWt: json['net_wt'] ?? '0',
      purWt: json['pur_wt'] ?? '0',
      diff: json['diff'] ?? '0',
    );
  }
}
