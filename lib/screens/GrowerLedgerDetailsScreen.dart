import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/plant_model.dart';
import '../models/purchase_model.dart';

class GrowerLedgerDetailsScreen extends StatefulWidget {
  final String villageGrower; // example: "111/25"

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

  Future<void> _init() async {
    final parts = widget.villageGrower.split('/');
    gVill = parts[0];
    gNo = parts.length > 1 ? parts[1] : "";

    plantCode = await Prefs.getPlantCode();

    if (plantCode.isEmpty) {
      debugPrint("❌ PlantCode not found");
      setState(() {
        loading = false;
        plantName = "Plant Code Not Found";
      });
      return;
    }

    await loadAll();
  }

  Future<void> loadAll() async {
    setState(() => loading = true);

    try {
      await Future.wait([
        fetchPlantName(),
        fetchGrowerName(),
        fetchFatherName(),
        fetchPurchaseDetails(),
        fetchSummary(),
      ]);
    } catch (_) {
      debugPrint("❌ Error fetching data");
    }

    if (mounted) setState(() => loading = false);
  }

  // ================= API CALLS =================

  Future<void> fetchPlantName() async {
    final sp = await SharedPreferences.getInstance();
    plantCode = sp.getString("PLANT_CODE") ?? "";

    if (plantCode.isEmpty) return;

    try {
      final plants = await ApiService.fetchPlants();
      final plant = plants.firstWhere(
            (e) => e.plantCode == plantCode,
        orElse: () => PlantModel(
          plantCode: plantCode,
          plantName: "Unknown Plant",
        ),
      );

      if (mounted) {
        setState(() {
          plantName = plant.plantName;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          plantName = "Server Error";
        });
      }
    }
  }

  Future<void> fetchGrowerName() async {
    final res = await ApiService.post("getGroweName.php", {
      "plantCode": plantCode,
      "g_vill": gVill,
      "g_no": gNo,
    });

    if (res["success"] == 1) {
      setState(() {
        growerName = res["growerName"] ?? "";
      });
    }
  }

  Future<void> fetchFatherName() async {
    final res = await ApiService.post("getGroweFather.php", {
      "plantCode": plantCode,
      "g_vill": gVill,
      "g_no": gNo,
    });

    if (res["success"] == 1) {
      setState(() {
        fatherName = res["growerName"] ?? "";
      });
    }
  }

  Future<void> fetchPurchaseDetails() async {
    final res = await ApiService.post("getGrowerDetails.php", {
      "plantCode": plantCode,
      "P_Vill": gVill,
      "P_GR_NO": gNo,
    });

    if (res["success"] == 1) {
      setState(() {
        purchases = (res["purchaseDetails"] as List)
            .map((e) => PurchaseModel.fromJson(e))
            .toList();
      });
    } else {
      setState(() {
        purchases = [];
      });
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
      setState(() {
        totalWeight = s["TOTAL_WEIGHT"].toString();
        totalAmount = s["TOTAL_AMOUNT"].toString();
        totalDeduction = s["TOTAL_DEDUCTION"].toString();
        netAmount = s["TOTAL_NETAMOUNT"].toString();
      });
    }
  }

  // ================= TABLE CELLS =================

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Add Grower Purchase Details Title =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey.shade200,
          child: const Center(
            child: Text(
              "GROWER PURCHASE DETAILS",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
        ),
        // Table header row
        Container(
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
        ),
      ],
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
      appBar: AppBar(
        title: const Text("Grower Ledger Details"),
        backgroundColor: const Color(0xFF2C4D76),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ===== HEADER INFO =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ PLANT NAME TOP CENTER
                Center(
                  child: Text(
                    plantName.isEmpty ? "Loading..." : plantName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
              ],
            ),
          ),

          // ===== TABLE =====
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 900, // Table width
                  child: ListView.builder(
                    itemCount: purchases.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return tableHeader();
                      return tableRow(purchases[index - 1], index - 1);
                    },
                  ),
                ),
              ),
            ),
          ),

          // ===== TOTALS =====
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 12),
            child: Wrap(
              spacing: 20,
              runSpacing: 6,
              children: [
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
        ],
      ),
    );
  }
}
