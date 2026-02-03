import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/ModeCountItem.dart';
import '../models/calendar_models.dart';
import '../models/grower_calendar_data.dart'; // ✅ ADD

class CalendarDetailsDesign extends StatefulWidget {
  final String village;
  final String grower;

  const CalendarDetailsDesign({
    super.key,
    required this.village,
    required this.grower,
  });

  @override
  State<CalendarDetailsDesign> createState() => _CalendarDetailsDesignState();
}

class _CalendarDetailsDesignState extends State<CalendarDetailsDesign> {
  GrowerDetails? details;
  List<ModeCountItem> modeItems = [];
  GrowerCalendarData? calendarData; // ✅ ADD

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadGrowerInfo();
  }

  Future<void> _loadGrowerInfo() async {
    try {
      final plantCode = await Prefs.getPlantCode();

      final d = await ApiService.fetchGrowerDetails(
        plantCode,
        widget.village,
        widget.grower,
      );

      final m = await ApiService.fetchGrowerModeCount(
        plantCode,
        widget.village,
        widget.grower,
      );

      final c = await ApiService.fetchGrowerCalendarData( // ✅ ADD
        plantCode,
        widget.village,
        widget.grower,
      );

      if (!mounted) return;

      setState(() {
        details = d;
        modeItems = m;
        calendarData = c;
        loading = false;
      });
    } catch (e) {
      loading = false;
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF2E7D32),
            child: const Text(
              "GROWER CALENDAR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _infoCard(),
                  const SizedBox(height: 8),
                  _summaryCard(),
                  const SizedBox(height: 8),
                  _areaYieldPurchyCard(), // ✅ NOW WORKING
                  const SizedBox(height: 8),
                  _calendarTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _infoCard() {
    if (details == null) return const SizedBox();
    final d = details!;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoText("Code : ${widget.village}/${widget.grower}"),
                  _InfoText("Village : ${d.vName}"),
                  _InfoText("Grower : ${d.gName}"),
                  _InfoText("S/O : ${d.gFather}"),
                  _InfoText("Society : ${d.gSocCd}"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoText("Centre : ${d.cnCode} ${d.cnName}"),
                  _InfoText("A/C : ${d.gBankAc}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY CARD =================
  Widget _summaryCard() {
    if (modeItems.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text("No summary data found"),
        ),
      );
    }

    final item = modeItems.first;

    String modeText;
    final mode = int.tryParse(item.mode) ?? 0;
    if (mode == 1) {
      modeText = "Cart";
    } else if (mode == 2) {
      modeText = "Trolley";
    } else {
      modeText = "Truck";
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _TopText("Centre\n${item.centre}"),
            _TopText("Mode\n$modeText"),
            _TopText("Count\n${item.totalCount}"),
            _TopText("Qty\n${item.totalWt}"),
          ],
        ),
      ),
    );
  }

  // ================= AREA / YIELD / PURCHY CARD =================
  Widget _areaYieldPurchyCard() {
    if (calendarData == null) return const SizedBox();

    final areaTotal =
        calendarData!.areaR + calendarData!.areaP;

    final yieldTotal =
        calendarData!.issueR + calendarData!.issueP;

    final purchyTotal =
        calendarData!.yieldR + calendarData!.yieldP;

    final issueTotal =
        calendarData!.purchyR + calendarData!.purchyP;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _areaHeaderRow(),

            _areaDataRow(
              "Area",
              calendarData!.areaR.toStringAsFixed(2),
              calendarData!.areaP.toStringAsFixed(2),
              areaTotal.toStringAsFixed(2),
            ),

            _areaDataRow(
              "Yield",
              calendarData!.yieldR.toString(),
              calendarData!.yieldP.toString(),
              purchyTotal.toString(),
              //yieldTotal.toString(),
            ),

            _areaDataRow(
              "Purchy",
              calendarData!.purchyR.toString(),
              calendarData!.purchyP.toString(),
              issueTotal.toString(),
            ),

            _areaDataRow(
              "Iss Purchy",
              calendarData!.issueR.toString(),
              calendarData!.issueP.toString(),
              yieldTotal.toString(),

            ),
          ],
        ),
      ),
    );
  }

  Widget _areaHeaderRow() {
    return Row(
      children: const [
        Expanded(child: SizedBox()),
        _HeaderCell("General (R)"),
        _HeaderCell("General (P)"),
        _HeaderCell("Total"),
      ],
    );
  }

  Widget _areaDataRow(String title, String r, String p, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          _DataCell(r),
          _DataCell(p),
          _DataCell(total),
        ],
      ),
    );
  }

  // ================= TABLE =================
  Widget _calendarTable() {
    return Card(
      elevation: 4,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          defaultColumnWidth: const FixedColumnWidth(40),
          children: List.generate(
            8,
                (row) => TableRow(
              children: List.generate(
                10,
                    (col) => Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    row == 0 ? "H$col" : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SMALL WIDGETS =================

class _InfoText extends StatelessWidget {
  final String text;
  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}

class _TopText extends StatelessWidget {
  final String text;
  const _TopText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  const _DataCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
