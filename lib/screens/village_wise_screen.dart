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
          Expanded(child: dataTable()),
          totalFixedBottom(),
        ],
      ),
    );
  }

  /// 🔷 HEADER
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

  /// 📊 MAIN TABLE (SCROLLABLE)
  Widget dataTable() {
    if (list.isEmpty) {
      return const Center(
        child: Text("No Data Found",
            style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 880,
        child: Column(
          children: [
            tableHeader(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (_, i) => tableRow(i + 1, list[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧱 HEADER ROW
  Widget tableHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔷 GROUP TITLE ROW
        Row(
          children: [
            const SizedBox(width: 40 + 60 + 160), // SN + Code + Centre Name

            groupHeader(
              "TODAY",
              70 + 70 + 70 + 80,
              bg: Colors.blue.shade200,
            ),

            groupHeader(
              "TODATE",
              70 + 70 + 70 + 80,
              bg: Colors.green.shade200,
            ),
          ],
        ),

        /// 🔷 COLUMN HEADER ROW
        Row(
          children: [
            headerCell("SN", 40),
            headerCell("Code", 60),
            headerCell("Centre Name", 160),

            /// TODAY
            headerCell("Early", 70, bg: Colors.blue.shade100),
            headerCell("General", 70, bg: Colors.blue.shade100),
            headerCell("Reject", 70, bg: Colors.blue.shade100),
            headerCell("Total", 80, bg: Colors.blue.shade100),

            /// TODATE
            headerCell("Early", 70, bg: Colors.green.shade100),
            headerCell("General", 70, bg: Colors.green.shade100),
            headerCell("Reject", 70, bg: Colors.green.shade100),
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
        cell(v.dayTrolley.toString(), 80),
        cell(v.dayTruck.toString(), 70),
        cell(v.dayWeight.toStringAsFixed(2), 80, color: Colors.blue),
        cell(v.toCart.toString(), 70),
        cell(v.toTrolley.toString(), 80),
        cell(v.toTruck.toString(), 70),
        cell(v.toWeight.toStringAsFixed(2), 80, color: Colors.green),
      ],
    );
  }

  /// 🔢 TOTAL FIXED BOTTOM
  Widget totalFixedBottom() {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            cell("", 40),
            cell("", 60),
            cell("TOTAL", 180, bold: true),
            cell(dayCart.toString(), 70, bold: true),
            cell(dayTrolley.toString(), 80, bold: true),
            cell(dayTruck.toString(), 70, bold: true),
            cell(dayWeight.toStringAsFixed(2), 80,
                bold: true, color: Colors.blue),
            cell(toCart.toString(), 70, bold: true),
            cell(toTrolley.toString(), 80, bold: true),
            cell(toTruck.toString(), 70, bold: true),
            cell(toWeight.toStringAsFixed(2), 80,
                bold: true, color: Colors.green),
          ],
        ),
      ),
    );
  }

  /// 🔹 CELL
  Widget cell(String text, double w, {bool bold = false, Color? color}) {
    return Container(
      width: w,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
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

  Widget groupHeader(String text, double width, {required Color bg}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget headerCell(String text, double w, {Color? bg}) {
    return Container(
      width: w,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg ?? Colors.blueGrey.shade200,
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
