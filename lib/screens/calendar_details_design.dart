import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/ModeCountItem.dart';
import '../models/calendar_models.dart';
import '../models/grower_calendar_data.dart';
import '../models/plant_model.dart';
import 'grower_calendar_details_design.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ================= DESIGN CONSTANTS =================
const primaryGreen = Color(0xFF2E7D32);
const lightGreen = Color(0xFFE8F5E9);
const headerGreen = Color(0xFF1B5E20);
const bgColor = Color(0xFFF5F7FA);
const cardRadius = 14.0;

// ================= RESPONSIVE HELPERS =================
bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 900;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;

class CalendarDetailsDesign extends StatefulWidget {
  final String plantCode;
  final String village;
  final String grower;

  const CalendarDetailsDesign({
    super.key,
    required this.plantCode,
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
  String plantName = "";

  bool loading = true;
  bool indentLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlant();
    _loadGrowerInfo();
  }


  Future<void> generatePDF() async {
    final pdf = pw.Document();

    final headerColor = PdfColor.fromInt(0xFF1B5E20);
    final lightGreen = PdfColor.fromInt(0xFFE8F5E9);
    final primaryGreen = PdfColor.fromInt(0xFF2E7D32);

    final now = DateTime.now();

    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? "PM" : "AM";

    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.year}  "
        "${hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')} $amPm";



    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [

          // ================= HEADER =================
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            color: primaryGreen,
            child: pw.Column(
              children: [

                pw.Center(
                  child: pw.Text(
                    "Grower Calendar",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),

                pw.Center(
                  child: pw.Text(
                    plantName,
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                ),

                pw.SizedBox(height: 5),

                // ✅ GENERATED DATE
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    "Generated On : $formattedDate",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),


          pw.SizedBox(height: 15),

          // ================= INFO CARD =================
          if (details != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: lightGreen,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Grower Info",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: headerColor)),
                  pw.SizedBox(height: 5),
                  pw.Text("Code : ${widget.village}/${widget.grower}"),
                  pw.Text("Village : ${details!.vName}"),
                  pw.Text("Grower : ${details!.gName}"),
                  pw.Text("Father : ${details!.gFather}"),
                  pw.Text("Society : ${details!.gSocCd}"),
                  pw.Text("Centre : ${details!.cnName}"),
                  pw.Text("Bank A/C : ${details!.gBankAc}"),
                  pw.Text("Mobile : ${details!.gMobile}"),
                ],
              ),
            ),

          pw.SizedBox(height: 15),

          // ================= SUMMARY =================
          if (modeItems.isNotEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: lightGreen,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Summary",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: headerColor)),
                  pw.Text("Centre : ${modeItems.first.centre}"),
                  pw.Text("Mode : ${modeItems.first.mode}"),
                  pw.Text("Count : ${modeItems.first.totalCount}"),
                  pw.Text("Qty : ${modeItems.first.totalWt}"),
                ],
              ),
            ),

          pw.SizedBox(height: 15),

          // ================= AREA / YIELD TABLE =================
          if (calendarData != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text("Area / Yield / Purchy",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: headerColor)),

                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [

                    // HEADER
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: lightGreen),
                      children: [
                        pw.Center(child: pw.Text("")),
                        pw.Center(child: pw.Text("General (R)")),
                        pw.Center(child: pw.Text("General (P)")),
                        pw.Center(child: pw.Text("Total")),
                      ],
                    ),

                    _pdfRow("Area",
                        calendarData!.areaR.toStringAsFixed(2),
                        calendarData!.areaP.toStringAsFixed(2),
                        (calendarData!.areaR + calendarData!.areaP).toStringAsFixed(2)),

                    _pdfRow("Yield",
                        calendarData!.yieldR.toString(),
                        calendarData!.yieldP.toString(),
                        (calendarData!.yieldR + calendarData!.yieldP).toString()),

                    _pdfRow("Purchy",
                        calendarData!.purchyR.toString(),
                        calendarData!.purchyP.toString(),
                        (calendarData!.purchyR + calendarData!.purchyP).toString()),

                    _pdfRow("Iss Purchy",
                        calendarData!.issueR.toString(),
                        calendarData!.issueP.toString(),
                        (calendarData!.issueR + calendarData!.issueP).toString()),
                  ],
                ),
              ],
            ),

          pw.SizedBox(height: 15),

          // ================= CALENDAR TABLE =================
          if (indentCalendar.isNotEmpty)
            pw.Table(
              border: pw.TableBorder.all(),
              children: [

                pw.TableRow(
                  decoration: pw.BoxDecoration(color: lightGreen),
                  children: [
                    pw.Center(child: pw.Text("Day")),
                    ...List.generate(
                        15,
                            (i) => pw.Center(child: pw.Text("${i + 1}"))),
                    pw.Center(child: pw.Text("Total")),
                  ],
                ),

                ...indentCalendar.keys.map((rowKey) {

                  final rowData = indentCalendar[rowKey] ?? {};
                  int rowTotal = 0;

                  List<pw.Widget> cells = [];

                  cells.add(pw.Center(child: pw.Text("Row-$rowKey")));

                  for (int day = 1; day <= 15; day++) {
                    final value = rowData[day] ?? 0;
                    rowTotal += value;

                    cells.add(pw.Center(child: pw.Text(value.toString())));
                  }

                  cells.add(pw.Center(child: pw.Text(rowTotal.toString())));

                  return pw.TableRow(children: cells);
                }).toList(),
              ],
            ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

// reusable pdf row
  pw.TableRow _pdfRow(String title, String r, String p, String total) {
    return pw.TableRow(children: [
      pw.Text(title),
      pw.Center(child: pw.Text(r)),
      pw.Center(child: pw.Text(p)),
      pw.Center(child: pw.Text(total)),
    ]);
  }



  Future<void> _loadPlant() async {
    try {
      final plants = await ApiService.fetchPlants();

      final plant = plants.firstWhere(
            (e) => e.plantCode == widget.plantCode,
        orElse: () => PlantModel(
          plantCode: widget.plantCode,
          plantName: "Unknown Plant",
        ),
      );

      if (!mounted) return;

      setState(() {
        plantName = plant.plantName;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        plantName = "Server Error";
      });
    }
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
        actions: [
          Tooltip(
            message: "Convert PDF",
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: generatePDF,
            ),
          ),
        ],
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
    final mobile = isMobile(context);

    return Card(
      elevation: 5,
      color: lightGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: mobile
        // 📱 MOBILE VIEW
            ? Column(
          children: [
            _infoRow("Code", "${widget.village}/${widget.grower}"),
            _infoRow("Village", d.vName),
            _infoRow("Grower", d.gName),
            _infoRow("Father", d.gFather),
            _infoRow("Society", d.gSocCd),
            _infoRow("Centre", "${d.cnCode} - ${d.cnName}"),
            _infoRow("Bank A/C", d.gBankAc),
            _infoRow("Mobile", d.gMobile),
          ],
        )
        // 💻 WEB / DESKTOP VIEW
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
            _infoItem("Mobile", d.gMobile),
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
              style: const TextStyle(
                fontSize: 11,
                color: headerGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  color: headerGreen,
                  fontWeight: FontWeight.bold)),
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
      color: lightGreen,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _statTile("Supply Centre", item.centre),
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
              style: const TextStyle(
                  fontSize: 11,
                  color: headerGreen,
                  fontWeight: FontWeight.bold)),
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
      color: lightGreen,
      elevation: 4,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: lightGreen,
      child: Row(
        children: const [
          Expanded(child: SizedBox()),
          _HeaderCell("General (R)"),
          _HeaderCell("General (P)"),
          _HeaderCell("Total"),
        ],
      ),
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(44),
          border: TableBorder.all(
              color: Colors.green.shade200),
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
      BoxDecoration(color: lightGreen),
      children: [
        _tableCell("Day", isHeader: true),
        for (int i = 1; i <= 15; i++)
          _tableCell(i.toString(), isHeader: true),
        _tableCell("Total", isHeader: true),
      ],
    );
  }

  // TableRow _calendarDataRow(int rowKey) {
  //   final rowData = indentCalendar[rowKey] ?? {};
  //   int rowTotal = 0;
  //
  //   for (int day = 1; day <= 15; day++) {
  //     rowTotal += rowData[day] ?? 0;
  //   }
  //
  //   String leftLabel =
  //   rowKey <= 4 ? "Rat-$rowKey" : "Pla-$rowKey";
  //
  //   return TableRow(
  //     children: [
  //       _tableCell(leftLabel, isHeader: true),
  //       for (int day = 1; day <= 15; day++)
  //         _tableCell((rowData[day] ?? 0).toString()),
  //       _tableCell(rowTotal.toString(), isHeader: true),
  //     ],
  //   );
  // }



  TableRow _calendarDataRow(int rowKey) {
    final rowData = indentCalendar[rowKey] ?? {};
    int rowTotal = 0;

    for (int day = 1; day <= 15; day++) {
      rowTotal += rowData[day] ?? 0;
    }

    // Sirf Row numbering
    final leftLabel = "Row-$rowKey";

    return TableRow(
      children: [
        _tableCell(leftLabel, isHeader: true),
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
          color: isHeader ? headerGreen : Colors.black87,
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: headerGreen),
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
