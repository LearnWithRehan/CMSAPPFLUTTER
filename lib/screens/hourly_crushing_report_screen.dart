import 'package:flutter/material.dart';

class HourlyCrushingReportScreen extends StatelessWidget {
  const HourlyCrushingReportScreen({super.key});

  TableRow headerRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
      children: _headerCells([
        "Hour", "Cart", "Wt", "Trolly", "Wt", "Truck", "Wt", "Total"
      ]),
    );
  }

  List<Widget> _headerCells(List<String> titles) {
    return titles
        .map(
          (e) => Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          e,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    )
        .toList();
  }

  TableRow dataRow(List<String> values, {bool bold = false}) {
    return TableRow(
      children: values
          .map(
            (e) => Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            e,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  TableRow dividerRow() {
    return TableRow(
      children: List.generate(
        8,
            (index) => const Center(
          child: Text(
            "—",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hourly Crushing Report"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            const Text(
              "Hourly Crushing Report",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2),

            Table(
              border: TableBorder.all(color: Colors.black26),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                headerRow(),

                /// ===== SHIFT A =====
                dataRow(["10-11", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["11-12", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["12-13", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["13-14", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["14-15", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["15-16", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["16-17", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["17-18", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),

                dividerRow(),

                dataRow(
                  ["Shift A", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"],
                  bold: true,
                ),

                dividerRow(),

                /// ===== SHIFT B =====
                dataRow(["18-19", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["19-20", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["20-21", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["21-22", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["22-23", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["23-24", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["00-01", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["01-02", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),

                dividerRow(),

                dataRow(
                  ["Shift B", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"],
                  bold: true,
                ),

                dividerRow(),

                /// ===== SHIFT C =====
                dataRow(["02-03", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["03-04", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["04-05", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["05-06", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["06-07", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["07-08", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["08-09", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),
                dataRow(["09-10", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"]),

                dividerRow(),

                dataRow(
                  ["Shift C", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"],
                  bold: true,
                ),

                dividerRow(),

                /// ===== TOTAL =====
                dataRow(
                  ["Total", "0", "00.00", "0", "00.00", "0", "00.00", "00.00"],
                  bold: true,
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              "Todate Purchase",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
