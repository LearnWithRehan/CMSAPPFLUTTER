import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/centre_purchase_model.dart';

class CentreWiseReportPurchaseScreen extends StatefulWidget {
  const CentreWiseReportPurchaseScreen({super.key});

  @override
  State<CentreWiseReportPurchaseScreen> createState() =>
      _CentreWiseReportPurchaseScreenState();
}

class _CentreWiseReportPurchaseScreenState
    extends State<CentreWiseReportPurchaseScreen> {
  List<CentrePurchaseModel> centres = [];
  bool loading = true;
  String selectedDate = "";

  double totalTodayWt = 0;
  double totalToDateWt = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final sp = await SharedPreferences.getInstance();
    final plant = sp.getString("PLANT_CODE") ?? "";
    selectedDate = sp.getString("SELECTED_DATECNT") ?? "";

    if (plant.isEmpty || selectedDate.isEmpty) return;

    centres = await ApiService.fetchCentreWisePurchase(plant, selectedDate);

    totalTodayWt = centres.fold(0, (s, e) => s + e.dailyWt);
    totalToDateWt = centres.fold(0, (s, e) => s + e.tillWt);

    setState(() => loading = false);
  }

  Widget headerCell(String text, double width) => Container(
    width: width,
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    color: const Color(0xFFEEF3F9),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color(0xFF2C4D76),
      ),
    ),
  );

  Widget dataCell(String text, double width,
      {bool bold = false, Color? color}) =>
      Container(
        width: width,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black87,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Centre Wise Purchase Report"),
        backgroundColor: const Color(0xFF2C4D76),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📅 Date
            Text(
              "Date : $selectedDate",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            /// 📊 TABLE / LIST
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            headerCell("SN", 60),
                            headerCell("Code", 80),
                            headerCell("Centre Name", 220),
                            headerCell("Today WT", 140),
                            headerCell("To Date WT", 160),
                          ],
                        ),

                        /// ROWS
                        ...List.generate(centres.length, (i) {
                          final c = centres[i];
                          final bg =
                          i.isEven ? Colors.white : const Color(0xFFF0F4FA);

                          return Container(
                            color: bg,
                            child: Row(
                              children: [
                                dataCell("${i + 1}", 60),
                                dataCell(c.code, 80),
                                dataCell(c.name, 220,
                                    bold: isWide),
                                dataCell(
                                    c.dailyWt.toStringAsFixed(2), 140),
                                dataCell(
                                    c.tillWt.toStringAsFixed(2), 160),
                              ],
                            ),
                          );
                        }),

                        /// 🔴 TOTAL
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C4D76),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              dataCell("TOTAL", 360,
                                  bold: true, color: Colors.white),
                              dataCell(
                                totalTodayWt.toStringAsFixed(2),
                                140,
                                bold: true,
                                color: Colors.white,
                              ),
                              dataCell(
                                totalToDateWt.toStringAsFixed(2),
                                160,
                                bold: true,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
