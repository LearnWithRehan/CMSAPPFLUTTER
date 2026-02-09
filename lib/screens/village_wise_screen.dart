import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/village_wise_model.dart';

class VillageWiseScreen extends StatefulWidget {
  const VillageWiseScreen({super.key});

  @override
  State<VillageWiseScreen> createState() => _VillageWiseScreenState();
}

class _VillageWiseScreenState extends State<VillageWiseScreen> {
  bool loading = true;
  String selectedDate = "";

  List<VillageWiseItem> list = [];

  int dayCart = 0, dayTrolley = 0, dayTruck = 0;
  double dayWeight = 0;

  int toCart = 0, toTrolley = 0, toTruck = 0;
  double toWeight = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE") ?? "";
    selectedDate = sp.getString("SELECTED_DATEVILLAGE") ?? "";

    list = await ApiService.fetchVillageWise(plantCode, selectedDate);
    calculateTotal();

    setState(() => loading = false);
  }

  void calculateTotal() {
    dayCart = 0;
    dayTrolley = 0;
    dayTruck = 0;
    dayWeight = 0;

    toCart = 0;
    toTrolley = 0;
    toTruck = 0;
    toWeight = 0;

    for (var v in list) {
      dayCart += v.dayCart;
      dayTrolley += v.dayTrolley;
      dayTruck += v.dayTruck;
      dayWeight += v.dayWeight;

      toCart += v.toCart;
      toTrolley += v.toTrolley;
      toTruck += v.toTruck;
      toWeight += v.toWeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: const Text("Village Wise Purchase"),
        backgroundColor: const Color(0xFF1F3C88),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          headerCard(),
          Expanded(child: tableWithTotal()),
        ],
      ),
    );
  }

  /// 🔷 HEADER CARD
  Widget headerCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "VILLAGE WISE PURCHASE REPORT",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Date : $selectedDate",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 TABLE + TOTAL (ONE SCROLL ONLY)
  Widget tableWithTotal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900,
        child: Column(
          children: [
            tableHeader(),

            /// DATA LIST (VERTICAL SCROLL)
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => tableRow(i + 1, list[i]),
              ),
            ),

            /// TOTAL ROW (NOW AUTO SYNC)
            totalRow(),
          ],
        ),
      ),
    );
  }

  /// 🧱 HEADER
  Widget tableHeader() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 40 + 60 + 180),
            groupHeader("TODAY", 290, Colors.blue.shade200),
            groupHeader("TODATE", 290, Colors.green.shade200),
          ],
        ),
        Row(
          children: [
            headerCell("SN", 40),
            headerCell("Code", 60),
            headerCell("Centre Name", 180),
            headerCell("Cart", 70, bg: Colors.blue.shade100),
            headerCell("Trolley", 70, bg: Colors.blue.shade100),
            headerCell("Truck", 70, bg: Colors.blue.shade100),
            headerCell("Total", 80, bg: Colors.blue.shade100),
            headerCell("Cart", 70, bg: Colors.green.shade100),
            headerCell("Trolley", 70, bg: Colors.green.shade100),
            headerCell("Truck", 70, bg: Colors.green.shade100),
            headerCell("Total", 80, bg: Colors.green.shade100),
          ],
        ),
      ],
    );
  }

  /// 📄 DATA ROW
  Widget tableRow(int sn, VillageWiseItem v) {
    return Row(
      children: [
        cell(sn.toString(), 40),
        cell(v.vCode, 60),
        cell(v.vName, 180),
        cell(v.dayCart.toString(), 70),
        cell(v.dayTrolley.toString(), 70),
        cell(v.dayTruck.toString(), 70),
        cell(v.dayWeight.toStringAsFixed(2), 80, color: Colors.blue),
        cell(v.toCart.toString(), 70),
        cell(v.toTrolley.toString(), 70),
        cell(v.toTruck.toString(), 70),
        cell(v.toWeight.toStringAsFixed(2), 80, color: Colors.green),
      ],
    );
  }

  /// 🔢 TOTAL ROW
  Widget totalRow() {
    return Container(
      color: Colors.blue.shade50,
      child: Row(
        children: [
          cell("", 40),
          cell("", 60),
          cell("TOTAL", 180, bold: true),
          cell(dayCart.toString(), 70, bold: true),
          cell(dayTrolley.toString(), 70, bold: true),
          cell(dayTruck.toString(), 70, bold: true),
          cell(dayWeight.toStringAsFixed(2), 80,
              bold: true, color: Colors.blue),
          cell(toCart.toString(), 70, bold: true),
          cell(toTrolley.toString(), 70, bold: true),
          cell(toTruck.toString(), 70, bold: true),
          cell(toWeight.toStringAsFixed(2), 80,
              bold: true, color: Colors.green),
        ],
      ),
    );
  }

  /// 🔹 CELL
  Widget cell(String text, double w,
      {bool bold = false, Color? color}) {
    return Container(
      width: w,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget groupHeader(String text, double width, Color bg) {
    return Container(
      width: width,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.black26),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget headerCell(String text, double w, {Color? bg}) {
    return Container(
      width: w,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg ?? Colors.blueGrey.shade200,
        border: Border.all(color: Colors.black26),
      ),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
