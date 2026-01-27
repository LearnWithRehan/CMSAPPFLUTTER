import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../models/hourly_row_model.dart';

class HourlyReportTwoToTwoScreen extends StatefulWidget {
  const HourlyReportTwoToTwoScreen({super.key});

  @override
  State<HourlyReportTwoToTwoScreen> createState() =>
      _HourlyReportTwoToTwoScreenState();
}

class _HourlyReportTwoToTwoScreenState
    extends State<HourlyReportTwoToTwoScreen> {

  double grandTotalPurchase = 0.0;

  List<HourlyRowModel> shiftA = []; // 02 AM – 10 AM
  List<HourlyRowModel> shiftB = []; // 10 AM – 06 PM
  List<HourlyRowModel> shiftC = []; // 06 PM – 02 AM

  bool loading = true;

  String plantCode = "";
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  /// ================= INIT =================
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();

    plantCode = sp.getString("PLANT_CODE") ?? "";
    selectedDate = sp.getString("SELECTED_DATEHOURLY") ?? "";

    await loadData();
    await loadGrandTotalPurchase();

    setState(() {
      loading = false;
    });
  }

  /// ================= SHIFT DATA (2–2 LOGIC) =================
  Future<void> loadData() async {
    /// 🔁 SHIFT ROTATION
    /// Shift A = 02 AM – 10 AM  -> ShiftC.php
    /// Shift B = 10 AM – 06 PM  -> ShiftA.php
    /// Shift C = 06 PM – 02 AM  -> ShiftB.php

    shiftA = await ApiService.fetchHourlyShift(
        "ShiftC.php", plantCode, selectedDate);

    shiftB = await ApiService.fetchHourlyShift(
        "ShiftA.php", plantCode, selectedDate);

    shiftC = await ApiService.fetchHourlyShift(
        "ShiftB.php", plantCode, selectedDate);
  }

  /// ================= GRAND TOTAL =================
  Future<void> loadGrandTotalPurchase() async {
    try {
      if (selectedDate.isEmpty) return;

      final res = await ApiService.getGrandTotal(selectedDate);

      if (res.success == 1) {
        setState(() {
          grandTotalPurchase = res.grandTotal;
        });
      }
    } catch (e) {
      debugPrint("Grand Total Error: $e");
    }
  }

  // ================= TOTAL CALCULATIONS =================

  int cartCount(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.cartCount);

  double cartWeight(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.cartWt);

  int trolleyCount(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.trolleyCount);

  double trolleyWeight(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.trolleyWt);

  int truckCount(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.truckCount);

  double truckWeight(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.truckWt);

  double netTotal(List<HourlyRowModel> l) =>
      l.fold(0, (s, e) => s + e.total);

  // ================= UI HELPERS =================

  Widget cell(String v, {bool bold = false}) => Padding(
    padding: const EdgeInsets.all(6),
    child: Text(
      v,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );

  TableRow headerRow() => TableRow(
    decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
    children: [
      "Hour", "Cart", "Wt", "Trolley", "Wt", "Truck", "Wt", "Total"
    ].map((e) => cell(e, bold: true)).toList(),
  );

  TableRow row(HourlyRowModel m) => TableRow(children: [
    cell(m.hour),
    cell("${m.cartCount}"),
    cell(m.cartWt.toStringAsFixed(2)),
    cell("${m.trolleyCount}"),
    cell(m.trolleyWt.toStringAsFixed(2)),
    cell("${m.truckCount}"),
    cell(m.truckWt.toStringAsFixed(2)),
    cell(m.total.toStringAsFixed(2)),
  ]);

  TableRow divider() => TableRow(
    children: List.generate(
      8,
          (_) => const Center(child: Text("—")),
    ),
  );

  TableRow totalRow(String title, List<HourlyRowModel> l) => TableRow(
    decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
    children: [
      cell(title, bold: true),
      cell(cartCount(l).toString(), bold: true),
      cell(cartWeight(l).toStringAsFixed(2), bold: true),
      cell(trolleyCount(l).toString(), bold: true),
      cell(trolleyWeight(l).toStringAsFixed(2), bold: true),
      cell(truckCount(l).toString(), bold: true),
      cell(truckWeight(l).toStringAsFixed(2), bold: true),
      cell(netTotal(l).toStringAsFixed(2), bold: true),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final all = [...shiftA, ...shiftB, ...shiftC];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hourly Report"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                "Date : $selectedDate",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          /// TABLE
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(70),
                  border: TableBorder.all(color: Colors.black26),
                  children: [
                    headerRow(),

                    ...shiftA.map(row),
                    divider(),
                    totalRow("Shift A (02–10)", shiftA),
                    divider(),

                    ...shiftB.map(row),
                    divider(),
                    totalRow("Shift B (10–18)", shiftB),
                    divider(),

                    ...shiftC.map(row),
                    divider(),
                    totalRow("Shift C (18–02)", shiftC),
                    divider(),

                    totalRow("TOTAL", all),
                  ],
                ),
              ),
            ),
          ),

          /// GRAND TOTAL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Text(
              "Todate Purchase : ${grandTotalPurchase.toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
