class ContractorModel {
  final String conName;
  final String conCode;

  ContractorModel({
    required this.conName,
    required this.conCode,
  });

  factory ContractorModel.fromJson(Map<String, dynamic> json) {
    return ContractorModel(
      conName: json['con_name'],
      conCode: json['con_code'],
    );
  }
}
