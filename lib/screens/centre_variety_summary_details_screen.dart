import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../models/centre_variety_summary_model.dart';

class CentreWiseVarietySummaryDetails extends StatefulWidget {
  const CentreWiseVarietySummaryDetails({super.key});

  @override
  State<CentreWiseVarietySummaryDetails> createState() =>
      _CentreWiseVarietySummaryDetailsState();
}

class _CentreWiseVarietySummaryDetailsState
    extends State<CentreWiseVarietySummaryDetails> {

  bool loading = true;
  List<CentreVarietyItem> list = [];
  String date = "";
  String plantCode = "";

  double dEarly = 0, dGeneral = 0, dReject = 0, dTotal = 0;
  double tEarly = 0, tGeneral = 0, tReject = 0, tTotal = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// 🔥 EXACT ANDROID BigDecimal (ROUND DOWN)
  String cut(double v) {
    final value = v.isNaN || v.isInfinite ? 0.0 : v;
    return ((value * 100).truncateToDouble() / 100)
        .toStringAsFixed(2);
  }

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    plantCode = sp.getString("PLANT_CODE") ?? "";
    date = sp.getString("SELECTED_DATECNTMILLVAR") ?? "";

    if (plantCode.isEmpty || date.isEmpty) {
      setState(() => loading = false);
      return;
    }

    try {
      final data =
      await ApiService.fetchCentreVarietySummary(plantCode, date);

      _calculateTotals(data);

      setState(() {
        list = data;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  void _calculateTotals(List<CentreVarietyItem> items) {
    dEarly = dGeneral = dReject = dTotal = 0;
    tEarly = tGeneral = tReject = tTotal = 0;

    for (final i in items) {
      dEarly += i.dailyEarly;
      dGeneral += i.dailyGeneral;
      dReject += i.dailyReject;
      dTotal += i.dailyTotal;

      tEarly += i.tillEarly;
      tGeneral += i.tillGeneral;
      tReject += i.tillReject;
      tTotal += i.tillTotal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Centre Variety Summary"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
              ],
            ),
          ),
        ),

      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
          ? const Center(child: Text("No Data Found"))
          : Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            /// ===== HEADER CARD =====
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const Text(
                    "Centre Variety Summary",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date : $date",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ===== TABLE =====
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1000,
                    child: Column(
                      children: [
                        _headerRow(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (_, i) =>
                                _dataRow(list[i], i),
                          ),
                        ),
                        _totalRow(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== HEADER =====
  Widget _headerRow() {
    return Column(
      children: [

        /// ===== FIRST HEADER ROW (Today / ToDate) =====
        Container(
          color: const Color(0xFF2C3E50),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: const [
              _H("SN", 40),
              _H("Code", 60),
              _H("Centre Name", 160),

              /// TODAY
              _H("Today", 290),

              /// TODATE
              _H("ToDate", 290),
            ],
          ),
        ),

        /// ===== SECOND HEADER ROW (Early / General / Reject / Total) =====
        Container(
          color: const Color(0xFF34495E),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: const [
              _H("", 40),
              _H("", 60),
              _H("", 160),

              _H("Early", 70),
              _H("General", 70),
              _H("Reject", 70),
              _H("Total", 80),

              _H("Early", 70),
              _H("General", 70),
              _H("Reject", 70),
              _H("Total", 80),
            ],
          ),
        ),
      ],
    );
  }


  /// ===== DATA ROW =====
  Widget _dataRow(CentreVarietyItem i, int index) {
    final bg = index.isEven ? Colors.white : const Color(0xFFF1F6FB);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _C("${index + 1}", 40),
          _C(i.cnCode, 60),
          _C(i.cnName, 160, align: TextAlign.start),
          _C(cut(i.dailyEarly), 70),
          _C(cut(i.dailyGeneral), 70),
          _C(cut(i.dailyReject), 70),
          _C(cut(i.dailyTotal), 80,
              bold: true, color: Colors.blue),
          _C(cut(i.tillEarly), 70),
          _C(cut(i.tillGeneral), 70),
          _C(cut(i.tillReject), 70),
          _C(cut(i.tillTotal), 80,
              bold: true, color: Colors.green),
        ],
      ),
    );
  }

  /// ===== TOTAL =====
  Widget _totalRow() {
    return Container(
      color: const Color(0xFF1E3799),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const _C("TOTAL", 260,
              bold: true, color: Colors.white),
          _C(cut(dEarly), 70, color: Colors.white),
          _C(cut(dGeneral), 70, color: Colors.white),
          _C(cut(dReject), 70, color: Colors.white),
          _C(cut(dTotal), 80,
              bold: true, color: Colors.yellowAccent),
          _C(cut(tEarly), 70, color: Colors.white),
          _C(cut(tGeneral), 70, color: Colors.white),
          _C(cut(tReject), 70, color: Colors.white),
          _C(cut(tTotal), 80,
              bold: true, color: Colors.orangeAccent),
        ],
      ),
    );
  }
}

/// ===== CELL =====
class _C extends StatelessWidget {
  final String text;
  final double w;
  final bool bold;
  final TextAlign align;
  final Color color;

  const _C(this.text, this.w,
      {this.bold = false,
        this.align = TextAlign.center,
        this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          fontWeight:
          bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}

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
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }
}
