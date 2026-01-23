import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YardPositionScreen extends StatelessWidget {
  const YardPositionScreen({super.key});

  Widget cell(String text,
      {bool bold = false, TextAlign align = TextAlign.center}) {
    return Expanded(
      child: Text(
        text,
        textAlign: align,
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
        children: values
            .map((e) => cell(e, bold: bold))
            .toList(),
      ),
    );
  }

  Widget titleLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("dd-MM-yyyy").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Yard Position"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// COMPANY NAME
            const Center(
              child: Text(
                "BHAGESHWOR SUGAR & CHEMICAL\nINDUSTRIES PVT. LTD.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            /// DATE
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Yard Position as on Date/Time:",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 6),


            const Divider(thickness: 1, height: 20),

            /// HEADER ROW
            row(
              ["Supply", "InYard", "InDonga", "Pur No", "TodayPur(Qty)"],
              bold: true,
            ),

            /// AT GATE
            titleLine("----------- AT GATE -----------"),

            row(["Cart", "5", "2", "20", "357.16"]),
            row(["Trolley", "114", "17", "68", "5666.48"]),
            row(["Truck", "0", "0", "2", "202.52"]),

            /// CENTRE RECEIPT
            titleLine("------- CENTRE RECEIPT -------"),

            row(["Truck", "0", "0", "0", "0.0"]),

            /// SEPARATOR
            titleLine("==========================================="),

            /// TOTAL
            row(["Total", "119", "19", "90", "6226.16"], bold: true),

            titleLine("==========================================="),

            const SizedBox(height: 10),

            /// TODATE PURCHASE
            const Text(
              "Todate Purchase : 817367.26",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
