import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/contractor_receipt_model.dart';

class ContractorDetailsScreen extends StatefulWidget {
  @override
  State<ContractorDetailsScreen> createState() =>
      _ContractorDetailsScreenState();
}

class _ContractorDetailsScreenState extends State<ContractorDetailsScreen> {
  List<ContractorReceiptModel> list = [];
  bool loading = true;

  double totalNet = 0, totalPur = 0, totalDiff = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final f = await Prefs.getContractorFilter();

    final data = await ApiService.getContractorReceipt(
      fromDate: f['fromDate']!,
      tillDate: f['tillDate']!,
      conCode: f['conCode']!,
    );

    totalNet = totalPur = totalDiff = 0;

    for (var i in data) {
      totalNet += double.tryParse(i.netWt) ?? 0;
      totalPur += double.tryParse(i.purWt) ?? 0;
      totalDiff += double.tryParse(i.diff) ?? 0;
    }

    setState(() {
      list = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contractor Report"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _tableHeader(),

          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final d = list[i];
                return _row(i + 1, d);
              },
            ),
          ),

          _totalBar(),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      height: 45,
      color: Colors.grey.shade300,
      child: Row(
        children: const [
          _HCell("SN", 0.7),
          _HCell("GatePass", 1.6),
          _HCell("Truck", 2.3),
          _HCell("Date", 2.0),
          _HCell("RWt", 1.3),
          _HCell("PurWt", 1.3),
          _HCell("Diff", 1.3),
        ],
      ),
    );
  }

  Widget _row(int sn, ContractorReceiptModel d) {
    final diffVal = double.tryParse(d.diff) ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          _cell(sn.toString(), 0.7),
          _cell(d.gatePass, 1.6),
          _cell(d.truckNo, 2.3),
          _cell(d.date, 2.0),
          _cell(d.netWt, 1.3, Colors.blue),
          _cell(d.purWt, 1.3, Colors.green),
          _cell(d.diff, 1.3,
              diffVal >= 0 ? Colors.green.shade800 : Colors.red),
        ],
      ),
    );
  }

  Widget _totalBar() {
    final diffColor =
    totalDiff >= 0 ? Colors.green.shade800 : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [

            /// 🔹 Total RWt
            const TextSpan(text: "Total RWt : "),
            TextSpan(
              text: totalNet.toStringAsFixed(2),
              style: const TextStyle(color: Colors.blue),
            ),

            const TextSpan(text: "   |   "),

            /// 🔹 PurWt
            const TextSpan(text: "PurWt : "),
            TextSpan(
              text: totalPur.toStringAsFixed(2),
              style: const TextStyle(color: Colors.green),
            ),

            const TextSpan(text: "   |   "),

            /// 🔹 Diff
            const TextSpan(text: "Diff : "),
            TextSpan(
              text: totalDiff.toStringAsFixed(2),
              style: TextStyle(color: diffColor),
            ),
          ],
        ),
      ),
    );
  }


  static Widget _cell(String text, double flex, [Color? color]) {
    return Expanded(
      flex: (flex * 10).toInt(),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: color),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _HCell extends StatelessWidget {
  final String text;
  final double flex;
  const _HCell(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: (flex * 10).toInt(),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
