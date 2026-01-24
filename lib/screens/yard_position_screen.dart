import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';

class YardPositionScreen extends StatefulWidget {
  const YardPositionScreen({super.key});

  @override
  State<YardPositionScreen> createState() => _YardPositionScreenState();
}

class _YardPositionScreenState extends State<YardPositionScreen> {
  String selectedDate = "";
  String plantName = "";

  @override
  void initState() {
    super.initState();
    _loadSelectedDate();
    loadData();
  }

  /// ================= LOAD PREF + API =================
  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();


    final plantCode = sp.getString("PLANT_CODE");
    if (plantCode != null) {
      plantName = await ApiService.fetchPlantNameByCode(plantCode);
    }

    setState(() {});
  }


  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDate = prefs.getString("SELECTED_DATE") ?? "";
    setState(() {});
  }

  Widget cell(String text, {bool bold = false}) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget row(List<String> values, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: values.map((e) => cell(e, bold: bold)).toList(),
      ),
    );
  }

  Widget titleLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yard Position"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                plantName.isEmpty
                    ? "Cane Management System"
                    : plantName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ✅ SELECTED DATE HERE
            Row(
              children: [
                const Expanded(
                  child: Text("Yard Position as on Date:"),
                ),
                Text(
                  selectedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(),

            row(
              ["Supply", "InYard", "InDonga", "Pur No", "TodayPur(Qty)"],
              bold: true,
            ),

            titleLine("----------- AT GATE -----------"),
            row(["Cart", "0", "0", "0", "00.00"]),
            row(["Trolley", "0", "0", "0", "00.00"]),
            row(["Truck", "0", "0", "0", "00.00"]),

            titleLine("------- CENTRE RECEIPT -------"),
            row(["Truck", "0", "0", "0", "0.0"]),

            titleLine("==================================="),
            row(["Total", "00", "00", "00", "00.00"], bold: true),
            titleLine("==================================="),

            const SizedBox(height: 10),
            const Text(
              "Todate Purchase : 00.00",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
