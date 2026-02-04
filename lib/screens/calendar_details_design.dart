import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/ModeCountItem.dart';
import '../models/calendar_models.dart';
import '../models/grower_calendar_data.dart';

// ================= DESIGN CONSTANTS =================
const primaryGreen = Color(0xFF2E7D32);
const bgColor = Color(0xFFF5F7FA);
const cardRadius = 14.0;

// ================= RESPONSIVE HELPERS =================
bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 900;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;

class CalendarDetailsDesign extends StatefulWidget {
  final String village;
  final String grower;

  const CalendarDetailsDesign({
    super.key,
    required this.village,
    required this.grower,
  });

  @override
  State<CalendarDetailsDesign> createState() =>
      _CalendarDetailsDesignState();
}

class _CalendarDetailsDesignState
    extends State<CalendarDetailsDesign> {
  GrowerDetails? details;
  List<ModeCountItem> modeItems = [];
  GrowerCalendarData? calendarData;
  Map<int, Map<int, int>> indentCalendar = {};

  bool loading = true;
  bool indentLoading = true;

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

      final c = await ApiService.fetchGrowerCalendarData(
        plantCode,
        widget.village,
        widget.grower,
      );

      final indent = await ApiService.fetchIndentCalendar(
        plantCode,
        widget.village,
        widget.grower,
      );

      if (!mounted) return;

      setState(() {
        details = d;
        modeItems = m;
        calendarData = c;
        indentCalendar = indent;
        loading = false;
        indentLoading = false;
      });
    } catch (e) {
      loading = false;
      indentLoading = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  // ================= MAIN UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text(
          "Grower Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          final padding =
          isDesktop(context) ? 24.0 : 12.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                _infoCard(),
                const SizedBox(height: 12),

                isDesktop(context)
                    ? Row(
                  children: [
                    Expanded(child: _summaryCard()),
                    const SizedBox(width: 12),
                    Expanded(
                        child:
                        _areaYieldPurchyCard()),
                  ],
                )
                    : Column(
                  children: [
                    _summaryCard(),
                    const SizedBox(height: 12),
                    _areaYieldPurchyCard(),
                  ],
                ),

                const SizedBox(height: 16),
                _calendarTable(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _infoCard() {
    if (details == null) return const SizedBox();
    final d = details!;

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: isMobile
            ? Column(
          children: [
            _infoRow("Code", "${widget.village}/${widget.grower}"),
            _infoRow("Village", d.vName),
            _infoRow("Grower", d.gName),
            _infoRow("Father", d.gFather),
            _infoRow("Society", d.gSocCd),
            _infoRow("Centre", "${d.cnCode} - ${d.cnName}"),
            _infoRow("Bank A/C", d.gBankAc),
          ],
        )
            : Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _infoItem("Code", "${widget.village}/${widget.grower}"),
            _infoItem("Village", d.vName),
            _infoItem("Grower", d.gName),
            _infoItem("Father", d.gFather),
            _infoItem("Society", d.gSocCd),
            _infoItem("Centre", "${d.cnCode} - ${d.cnName}"),
            _infoItem("Bank A/C", d.gBankAc),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _infoItem(String title, String value) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ================= SUMMARY CARD =================
  Widget _summaryCard() {
    if (modeItems.isEmpty) return const SizedBox();
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _statTile("Centre", item.centre),
            _statTile("Mode", modeText),
            _statTile("Count", item.totalCount),
            _statTile("Qty", item.totalWt),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ================= AREA / YIELD / PURCHY =================
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _areaHeaderRow(),
            _areaDataRow("Area",
                calendarData!.areaR.toStringAsFixed(2),
                calendarData!.areaP.toStringAsFixed(2),
                areaTotal.toStringAsFixed(2)),
            _areaDataRow("Yield",
                calendarData!.yieldR.toString(),
                calendarData!.yieldP.toString(),
                purchyTotal.toString()),
            _areaDataRow("Purchy",
                calendarData!.purchyR.toString(),
                calendarData!.purchyP.toString(),
                issueTotal.toString()),
            _areaDataRow("Iss Purchy",
                calendarData!.issueR.toString(),
                calendarData!.issueP.toString(),
                yieldTotal.toString()),
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

  Widget _areaDataRow(
      String title, String r, String p, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          _DataCell(r),
          _DataCell(p),
          _DataCell(total),
        ],
      ),
    );
  }

  // ================= CALENDAR TABLE =================
  Widget _calendarTable() {
    if (indentLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (indentCalendar.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Text("No calendar data found"),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(44),
          border: TableBorder.all(
              color: Colors.grey.shade300),
          children: [
            _calendarHeaderRow(),
            ...indentCalendar.keys.map(_calendarDataRow),
          ],
        ),
      ),
    );
  }

  TableRow _calendarHeaderRow() {
    return TableRow(
      decoration:
      BoxDecoration(color: Colors.grey.shade200),
      children: [
        _tableCell("Day", isHeader: true),
        for (int i = 1; i <= 15; i++)
          _tableCell(i.toString(), isHeader: true),
        _tableCell("Total", isHeader: true),
      ],
    );
  }

  TableRow _calendarDataRow(int rowKey) {
    final rowData = indentCalendar[rowKey] ?? {};
    int rowTotal = 0;
    for (int day = 1; day <= 15; day++) {
      rowTotal += rowData[day] ?? 0;
    }

    return TableRow(
      children: [
        _tableCell("R$rowKey"),
        for (int day = 1; day <= 15; day++)
          _tableCell((rowData[day] ?? 0).toString()),
        _tableCell(rowTotal.toString(), isHeader: true),
      ],
    );
  }

  Widget _tableCell(String text,
      {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight:
          isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// ================= SMALL WIDGETS =================
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold),
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
