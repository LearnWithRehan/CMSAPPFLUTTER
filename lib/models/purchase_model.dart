class PurchaseModel {
  final String pnum;
  final String adv;
  final String purDate;
  final String variety;
  final String weight;
  final String rate;
  final String amount;
  final String payDate;
  final String deduction;
  final String netAmount;
  final String status;

  PurchaseModel({
    required this.pnum,
    required this.adv,
    required this.purDate,
    required this.variety,
    required this.weight,
    required this.rate,
    required this.amount,
    required this.payDate,
    required this.deduction,
    required this.netAmount,
    required this.status,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      pnum: json["P_NUMBER"]?.toString() ?? "",
      adv: json["P_BANKADV"]?.toString() ?? "",
      purDate: json["P_DATE"]?.toString() ?? "",
      variety: json["P_VARITY"]?.toString() ?? "",
      weight: json["P_NETWT"]?.toString() ?? "0",
      rate: json["P_RATE"]?.toString() ?? "0",
      amount: json["P_AMOUNT"]?.toString() ?? "0",
      payDate: json["P_PAYDT"]?.toString() ?? "",
      deduction: json["P_LOANDED"]?.toString() ?? "0",
      netAmount: json["P_NETAMT"]?.toString() ?? "0",
      status: json["P_STATUS"]?.toString() ?? "",
    );
  }
}
