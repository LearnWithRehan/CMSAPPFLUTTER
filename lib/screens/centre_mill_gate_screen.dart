import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/centre_mill_gate_model.dart';

class CentreMillGateScreen extends StatefulWidget {
  const CentreMillGateScreen({Key? key}) : super(key: key);

  @override
  State<CentreMillGateScreen> createState() => _CentreMillGateScreenState();
}

class _CentreMillGateScreenState extends State<CentreMillGateScreen> {
  bool loading = true;
  List<CentreMillGateModel> list = [];

  double tPurD = 0, tRecD = 0, tTotD = 0;
  double tPurT = 0, tRecT = 0, tTotT = 0;

  String date = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final plantCode = await Prefs.getPlantCode();
    final sp = await SharedPreferences.getInstance();
    date = sp.getString("SELECTED_DATECNTMILL") ?? "";

    final data = await ApiService.fetchCentreMillGate(
      plantCode: plantCode,
      date: date,
    );

    /// 🔥 TOTAL CALCULATION (Backend data se)
    for (var e in data) {
      tPurD += e.purDaily;
      tRecD += e.recDaily;
      tTotD += e.dailyTotal;
      tPurT += e.purTill;
      tRecT += e.recTill;
      tTotT += e.tillTotal;
    }

    setState(() {
      list = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Centre & Mill Gate"),
        backgroundColor: const Color(0xFF2C4D76),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// 🔷 HEADER
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    "CENTRE AND MILL GATE PURCHASE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date : $date",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 📊 TABLE
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 820,
                  child: Column(
                    children: [

                      _headerRow(),

                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) =>
                              _dataRow(i + 1, list[i]),
                        ),
                      ),

                      const Divider(thickness: 1),

                      _totalRow(),
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

  Widget _headerRow() {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: const [
          _H("SN", 50),
          _H("Code", 60),
          _H("Centre Name", 160),
          _H("MillGate", 90),
          _H("Centre", 90),
          _H("Total", 90),
          _H("MillGate", 90),
          _H("Centre", 90),
          _H("Total", 90),
        ],
      ),
    );
  }

  Widget _dataRow(int sn, CentreMillGateModel d) {
    return _row(
      sn.toString(),
      d.code,
      d.name,
      d.purDaily,
      d.recDaily,
      d.dailyTotal,
      d.purTill,
      d.recTill,
      d.tillTotal,
      false,
    );
  }

  Widget _totalRow() {
    return _row(
      "",
      "",
      "TOTAL",
      tPurD,
      tRecD,
      tTotD,
      tPurT,
      tRecT,
      tTotT,
      true,
    );
  }

  Widget _row(
      String sn,
      String code,
      String name,
      double pd,
      double rd,
      double td,
      double pt,
      double rt,
      double tt,
      bool isTotal,
      ) {
    TextStyle style = TextStyle(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal ? Colors.blue.shade800 : Colors.black,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          _C(sn, 50, style),
          _C(code, 60, style),
          _C(name, 160, style),
          _C(pd.toStringAsFixed(2), 90, style),
          _C(rd.toStringAsFixed(2), 90, style),
          _C(td.toStringAsFixed(2), 90, style),
          _C(pt.toStringAsFixed(2), 90, style),
          _C(rt.toStringAsFixed(2), 90, style),
          _C(tt.toStringAsFixed(2), 90, style),
        ],
      ),
    );
  }
}

/// 🔹 Header Cell
class _H extends StatelessWidget {
  final String t;
  final double w;
  const _H(this.t, this.w);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Text(
        t,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// 🔹 Data Cell
Widget _C(String t, double w, TextStyle s) {
  return SizedBox(
    width: w,
    child: Text(
      t,
      textAlign: TextAlign.center,
      style: s,
    ),
  );
}
