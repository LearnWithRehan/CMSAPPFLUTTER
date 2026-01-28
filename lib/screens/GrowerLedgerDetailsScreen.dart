import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/purchase_model.dart';

class GrowerLedgerDetailsScreen extends StatefulWidget {
  /// example: "111/25"
  final String villageGrower;

  const GrowerLedgerDetailsScreen({
    super.key,
    required this.villageGrower,
  });

  @override
  State<GrowerLedgerDetailsScreen> createState() =>
      _GrowerLedgerDetailsScreenState();
}

class _GrowerLedgerDetailsScreenState
    extends State<GrowerLedgerDetailsScreen> {

  bool loading = true;

  String plantCode = "";
  String gVill = "";
  String gNo = "";

  String plantName = "";
  String growerName = "";
  String fatherName = "";

  List<PurchaseModel> purchases = [];

  String totalWeight = "0";
  String totalAmount = "0";
  String totalDeduction = "0";
  String netAmount = "0";

  final String now =
  DateFormat('dd-MMM-yy   hh:mm:ss a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ================= INIT =================

  Future<void> _init() async {
    final parts = widget.villageGrower.split('/');
    gVill = parts[0];
    gNo = parts.length > 1 ? parts[1] : "";

    plantCode = await Prefs.getPlantCode();

    if (plantCode.isEmpty) {
      debugPrint("❌ PlantCode not found");
      return;
    }

    await loadAll();
  }

  Future<void> loadAll() async {
    setState(() => loading = true);

    await Future.wait([
      fetchPlantName(),
      fetchGrowerName(),
      fetchFatherName(),
      fetchPurchaseDetails(),
      fetchSummary(),
    ]);

    if (mounted) {
      setState(() => loading = false);
    }
  }

  // ================= API CALLS =================

  Future<void> fetchPlantName() async {
    final res = await ApiService.post("getPlantName.php", {
      "plantCode": plantCode,
    });

    if (res["success"] == 1) {
      plantName = res["plant_name"] ?? "";
    }
  }

  Future<void> fetchGrowerName() async {
    final res = await ApiService.post("getGroweName.php", {
      "plantCode": plantCode,
      "g_vill": gVill,
      "g_no": gNo,
    });

    if (res["success"] == 1) {
      growerName = res["growerName"] ?? "";
    }
  }

  Future<void> fetchFatherName() async {
    final res = await ApiService.post("getGroweFather.php", {
      "plantCode": plantCode,
      "g_vill": gVill,
      "g_no": gNo,
    });

    if (res["success"] == 1) {
      fatherName = res["growerName"] ?? "";
    }
  }

  /// 🔥 MAIN FIXED API CALL (अब data आएगा)
  Future<void> fetchPurchaseDetails() async {
    final res = await ApiService.post("getGrowerDetails.php", {
      "plantCode": plantCode,
      "P_Vill": gVill,
      "P_GR_NO": gNo,
    });

    if (res["success"] == 1) {
      purchases = (res["purchaseDetails"] as List)
          .map((e) => PurchaseModel.fromJson(e))
          .toList();
    } else {
      purchases = [];
    }
  }

  Future<void> fetchSummary() async {
    final res = await ApiService.post("SumTotalGrowerLedger.php", {
      "plantCode": plantCode,
      "P_Vill": gVill,
      "P_GR_NO": gNo,
    });

    if (res["success"] == 1) {
      final s = res["summary"];
      totalWeight = s["TOTAL_WEIGHT"].toString();
      totalAmount = s["TOTAL_AMOUNT"].toString();
      totalDeduction = s["TOTAL_DEDUCTION"].toString();
      netAmount = s["TOTAL_NETAMOUNT"].toString();
    }
  }

  // ================= TABLE =================

  Widget cell(String text, double width, {bool bold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget tableHeader() {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(6),
      child: Row(children: [
        cell("SN", 40, bold: true),
        cell("PNUM", 80, bold: true),
        cell("ADV", 60, bold: true),
        cell("DATE", 90, bold: true),
        cell("VAR", 60, bold: true),
        cell("WT", 60, bold: true),
        cell("RATE", 60, bold: true),
        cell("AMT", 70, bold: true),
        cell("PAYDT", 90, bold: true),
        cell("DED", 60, bold: true),
        cell("NET", 70, bold: true),
        cell("STATUS", 80, bold: true),
      ]),
    );
  }

  Widget tableRow(PurchaseModel p, int i) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(children: [
        cell("${i + 1}", 40),
        cell(p.pnum, 80),
        cell(p.adv, 60),
        cell(p.purDate, 90),
        cell(p.variety, 60),
        cell(p.weight, 60),
        cell(p.rate, 60),
        cell(p.amount, 70),
        cell(p.payDate, 90),
        cell(p.deduction, 60),
        cell(p.netAmount, 70),
        cell(p.status, 80),
      ]),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Grower Ledger Details")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                plantName,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Text("Grower Code : $gVill/$gNo",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue)),
            Text("Grower Name : $growerName",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Father Name : $fatherName",
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const Divider(thickness: 2),

            /// ===== TABLE =====
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  tableHeader(),
                  ...List.generate(
                    purchases.length,
                        (i) => tableRow(purchases[i], i),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 2),

            Text("TOTAL Weight : $totalWeight",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue)),
            Text("TOTAL Amount : $totalAmount",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            Text("TOTAL Deduction : $totalDeduction",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red)),
            Text("TOTAL PAID AMT : $netAmount",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
