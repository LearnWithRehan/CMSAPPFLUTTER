import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VarietyWiseReportScreen extends StatefulWidget {
  const VarietyWiseReportScreen({super.key});

  @override
  State<VarietyWiseReportScreen> createState() =>
      _VarietyWiseReportScreenState();
}

class _VarietyWiseReportScreenState
    extends State<VarietyWiseReportScreen> {
  String plantName = "";
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    loadHeaderData();
  }

  Future<void> loadHeaderData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      plantName = sp.getString("PLANT_NAME") ??
          "BHAGESHWOR SUGAR & CHEMICAL INDUSTRIES PVT LTD";
      selectedDate =
          sp.getString("SELECTED_DATEVAR") ?? "";
    });
  }

  TextStyle header =
  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  TextStyle cell =
  const TextStyle(fontSize: 14, color: Colors.black);

  Widget tableCell(String text,
      {bool bold = false, Alignment align = Alignment.center}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: TextStyle(
            fontSize: bold ? 15 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  /// 🏭 PLANT NAME
                  Text(
                    plantName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// 📊 TITLE
                  const Text(
                    "VARIETY WISE CRUSHING REPORT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 📅 DATE ROW
                  Row(
                    children: [
                      Text(
                        "DATE: $selectedDate",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(thickness: 2, color: Colors.black),

                  /// 📋 TABLE
                  Table(
                    defaultColumnWidth:
                    const IntrinsicColumnWidth(),
                    border: const TableBorder(
                      horizontalInside:
                      BorderSide(color: Colors.grey),
                    ),
                    children: [

                      /// HEADER
                      TableRow(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300),
                        children: [
                          tableCell("SN", bold: true),
                          tableCell("CODE", bold: true),
                          tableCell("NAME", bold: true),
                          tableCell("TODAY", bold: true),
                          tableCell("%", bold: true),
                          tableCell("TODATE", bold: true),
                          tableCell("%", bold: true),
                        ],
                      ),

                      /// EARLY
                      TableRow(children: [
                        tableCell("1"),
                        tableCell("31"),
                        tableCell("EARLY",
                            align: Alignment.centerLeft),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                      ]),

                      /// GENERAL
                      TableRow(children: [
                        tableCell("2"),
                        tableCell("32"),
                        tableCell("GENERAL",
                            align: Alignment.centerLeft),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                      ]),

                      /// REJECT
                      TableRow(children: [
                        tableCell("3"),
                        tableCell("33"),
                        tableCell("REJECT",
                            align: Alignment.centerLeft),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                        tableCell("0"),
                      ]),

                      /// TOTAL
                      TableRow(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200),
                        children: [
                          tableCell("TOTAL",
                              bold: true, align: Alignment.centerLeft),
                          tableCell(""),
                          tableCell(""),
                          tableCell("0", bold: true),
                          tableCell(""),
                          tableCell("0", bold: true),
                          tableCell(""),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
