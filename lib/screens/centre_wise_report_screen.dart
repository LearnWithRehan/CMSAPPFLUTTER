import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CentreWiseReportScreen extends StatefulWidget {
  const CentreWiseReportScreen({super.key});

  @override
  State<CentreWiseReportScreen> createState() => _CentreWiseReportScreenState();
}

class _CentreWiseReportScreenState extends State<CentreWiseReportScreen> {
  String selectedDate = "";

  /// 🔹 Dummy data (API ke baad replace kar dena)
  final List<Map<String, dynamic>> rows = List.generate(10, (i) {
    return {
      "sn": i + 1,
      "code": "C10$i",
      "name": "Centre ${i + 1}",
      "trollyToday": 5 + i,
      "cartToday": 3,
      "truckToday": 2,
      "wtToday": 120 + i,
      "trollyTD": 50 + i,
      "cartTD": 30,
      "truckTD": 20,
      "total": 200 + i,
    };
  });

  @override
  void initState() {
    super.initState();
    loadDate();
  }

  Future<void> loadDate() async {
    final sp = await SharedPreferences.getInstance();
    selectedDate =
        sp.getString("SELECTED_DATE_CENTRE") ??
            DateFormat('dd-MM-yyyy').format(DateTime.now());
    setState(() {});
  }

  /// 🔹 Table Header Cell
  Widget headerCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      color: Colors.grey.shade300,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 🔹 Table Data Cell
  Widget dataCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("CENTRE WISE PURCHASE"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C4D76),
      ),
      body: Column(
        children: [

          /// 📅 DATE
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Date At: $selectedDate",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),

          const Divider(thickness: 1),

          /// ================= SCROLL AREA =================
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 950,
                child: Column(
                  children: [

                    /// 🔹 TOP TEXT
                    const Padding(
                      padding: EdgeInsets.only(left: 170, bottom: 6),
                      child: Text(
                        "<<== To Day Purchase ==>>     <<== To Date Purchase ==>>",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),

                    /// ================= HEADER ROW =================
                    Row(
                      children: [
                        headerCell("SN", 40),
                        headerCell("Code", 55),
                        headerCell("Centre Name", 140),
                        headerCell("Trolly", 60),
                        headerCell("Cart", 50),
                        headerCell("Truck", 60),
                        headerCell("WT", 70),
                        headerCell("Trolly", 60),
                        headerCell("Cart", 60),
                        headerCell("Truck", 60),
                        headerCell("Total", 100),
                      ],
                    ),

                    /// ================= DATA ROWS =================
                    Expanded(
                      child: ListView.builder(
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final r = rows[index];
                          return Row(
                            children: [
                              dataCell("${r['sn']}", 40),
                              dataCell(r['code'], 55),
                              dataCell(r['name'], 140),
                              dataCell("${r['trollyToday']}", 60),
                              dataCell("${r['cartToday']}", 50),
                              dataCell("${r['truckToday']}", 60),
                              dataCell("${r['wtToday']}", 70),
                              dataCell("${r['trollyTD']}", 60),
                              dataCell("${r['cartTD']}", 60),
                              dataCell("${r['truckTD']}", 60),
                              dataCell("${r['total']}", 100),
                            ],
                          );
                        },
                      ),
                    ),

                    const Divider(thickness: 2),

                    /// ================= TOTAL ROW =================
                    Row(
                      children: [
                        dataCell("", 40),
                        dataCell("", 55),
                        dataCell("TOTAL", 140),
                        dataCell("50", 60),
                        dataCell("30", 50),
                        dataCell("20", 60),
                        dataCell("120", 70),
                        dataCell("500", 60),
                        dataCell("300", 60),
                        dataCell("200", 60),
                        dataCell("1000", 100),
                      ],
                    ),

                    const Divider(thickness: 2),
                  ],
                ),
              ),
            ),
          ),

          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
