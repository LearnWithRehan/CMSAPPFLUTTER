import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/centre_kudiya_purchase_model.dart';
class CenterWiseReportScreenKudiyaPurchase extends StatefulWidget {
  const CenterWiseReportScreenKudiyaPurchase({super.key});

  @override
  State<CenterWiseReportScreenKudiyaPurchase> createState() =>
      _CenterWiseReportScreenKudiyaPurchaseState();
}

class _CenterWiseReportScreenKudiyaPurchaseState
    extends State<CenterWiseReportScreenKudiyaPurchase> {
  List<CentreKudiyaPurchaseModel> centres = [];
  bool loading = true;
  String selectedDate = "";

  double totalDailyWt = 0;
  double totalTillWt = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final plantCode = sp.getString("PLANT_CODE") ?? "";
      selectedDate = sp.getString("SELECTED_DATECNT") ?? "";

      if (plantCode.isEmpty || selectedDate.isEmpty) {
        setState(() => loading = false);
        return;
      }

      centres = await ApiService.fetchCentreWiseKudiyaPurchase(
        plantCode,
        selectedDate,
      );

      totalDailyWt = centres.fold(0, (s, e) => s + e.dailyWt);
      totalTillWt = centres.fold(0, (s, e) => s + e.tillWt);
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    setState(() => loading = false);
  }

  Widget header(String t, double w) => Container(
    width: w,
    padding: const EdgeInsets.all(10),
    color: const Color(0xFFE8EEF6),
    alignment: Alignment.center,
    child: Text(t,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C4D76))),
  );

  Widget cell(String t, double w,
      {bool bold = false, Color? color}) =>
      Container(
        width: w,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          t,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black87,
            fontSize: 13,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Centre Wise Kudiya Purchase"),
        backgroundColor: const Color(0xFF2C4D76),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date : $selectedDate",
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(children: [
                        header("SN", 50),
                        header("Code", 70),
                        header("Centre", 200),
                        header("D WT", 120),
                        header("T WT", 120),
                      ]),
                      ...List.generate(centres.length, (i) {
                        final c = centres[i];
                        return Row(children: [
                          cell("${i + 1}", 50),
                          cell(c.code, 70),
                          cell(c.name, 200, bold: true),
                          cell(c.dailyWt.toStringAsFixed(2), 120),
                          cell(c.tillWt.toStringAsFixed(2), 120),
                        ]);
                      }),
                      Container(
                        color: const Color(0xFF2C4D76),
                        child: Row(children: [
                          cell("TOTAL", 320,
                              bold: true, color: Colors.white),
                          cell(
                            totalDailyWt.toStringAsFixed(2),
                            120,
                            bold: true,
                            color: Colors.white,
                          ),
                          cell(
                            totalTillWt.toStringAsFixed(2),
                            120,
                            bold: true,
                            color: Colors.white,
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
