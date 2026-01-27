import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/centre_model.dart';

class CentreWiseReportScreen extends StatefulWidget {
  const CentreWiseReportScreen({super.key});

  @override
  State<CentreWiseReportScreen> createState() =>
      _CentreWiseReportScreenState();
}

class _CentreWiseReportScreenState extends State<CentreWiseReportScreen> {
  bool loading = true;
  List<CentreModel> centres = [];
  String selectedDate = "";
  String error = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final sp = await SharedPreferences.getInstance();
      selectedDate = sp.getString("SELECTED_DATE_CENTRE") ?? "";

      if (selectedDate.isEmpty) {
        throw Exception("Selected date not found");
      }

      final res = await ApiService.getCentreReport(selectedDate);

      if (res.success == 1) {
        setState(() {
          centres = res.centres;
          loading = false;
        });
      } else {
        throw Exception("No data");
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // ================= TOTAL HELPERS =================
  int sumInt(int Function(CentreModel c) f) =>
      centres.fold(0, (s, c) => s + f(c));

  double sumDouble(double Function(CentreModel c) f) =>
      centres.fold(0.0, (s, c) => s + f(c));

  // ================= CELL =================
  Widget cell(String text, double w,
      {bool bold = false, Color? bg}) {
    return Container(
      width: w,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Centre Wise Purchase")),
        body: Center(child: Text(error)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("CENTRE WISE PURCHASE"),
        backgroundColor: const Color(0xFF2C4D76),
      ),
      body: Column(
        children: [

          /// DATE
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Date At : $selectedDate",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 980,
                  child: ListView(
                    children: [

                      /// ===== GROUP HEADER =====
                      Row(children: [
                        cell("", 40, bg: Colors.grey[200]),
                        cell("", 60, bg: Colors.grey[200]),
                        cell("", 140, bg: Colors.grey[200]),
                        cell("TODAY", 250,
                            bold: true, bg: Colors.blue[100]),
                        cell("TO DATE", 250,
                            bold: true, bg: Colors.green[100]),
                      ]),

                      /// ===== COLUMN HEADER =====
                      Row(children: [
                        cell("SN", 40, bold: true, bg: Colors.grey[300]),
                        cell("Code", 60, bold: true, bg: Colors.grey[300]),
                        cell("Centre", 140, bold: true, bg: Colors.grey[300]),

                        cell("Trolly", 60, bold: true, bg: Colors.grey[300]),
                        cell("Cart", 60, bold: true, bg: Colors.grey[300]),
                        cell("Truck", 60, bold: true, bg: Colors.grey[300]),
                        cell("WT", 70, bold: true, bg: Colors.grey[300]),

                        cell("Trolly", 60, bold: true, bg: Colors.grey[300]),
                        cell("Cart", 60, bold: true, bg: Colors.grey[300]),
                        cell("Truck", 60, bold: true, bg: Colors.grey[300]),
                        cell("WT", 70, bold: true, bg: Colors.grey[300]),
                      ]),

                      /// ===== DATA ROWS =====
                      ...centres.asMap().entries.map((e) {
                        final i = e.key + 1;
                        final c = e.value;
                        return Row(children: [
                          cell("$i", 40),
                          cell(c.code, 60),
                          cell(c.name, 140),

                          cell("${c.dailyTrolley}", 60),
                          cell("${c.dailyCart}", 60),
                          cell("${c.dailyTruck}", 60),
                          cell(c.dailyWT.toStringAsFixed(2), 70),

                          cell("${c.tillTrolley}", 60),
                          cell("${c.tillCart}", 60),
                          cell("${c.tillTruck}", 60),
                          cell(c.tillWT.toStringAsFixed(2), 70),
                        ]);
                      }),

                      /// ===== TOTAL ROW =====
                      Row(children: [
                        cell("", 40, bold: true, bg: Colors.grey[200]),
                        cell("", 60, bold: true, bg: Colors.grey[200]),
                        cell("TOTAL", 140,
                            bold: true, bg: Colors.grey[200]),

                        cell("${sumInt((c) => c.dailyTrolley)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell("${sumInt((c) => c.dailyCart)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell("${sumInt((c) => c.dailyTruck)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell(sumDouble((c) => c.dailyWT)
                            .toStringAsFixed(2), 70,
                            bold: true, bg: Colors.grey[200]),

                        cell("${sumInt((c) => c.tillTrolley)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell("${sumInt((c) => c.tillCart)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell("${sumInt((c) => c.tillTruck)}", 60,
                            bold: true, bg: Colors.grey[200]),
                        cell(sumDouble((c) => c.tillWT)
                            .toStringAsFixed(2), 70,
                            bold: true, bg: Colors.grey[200]),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
