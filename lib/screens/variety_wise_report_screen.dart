import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/plant_model.dart';

class VarietyWiseReportScreen extends StatefulWidget {
  const VarietyWiseReportScreen({super.key});

  @override
  State<VarietyWiseReportScreen> createState() =>
      _VarietyWiseReportScreenState();
}

class _VarietyWiseReportScreenState
    extends State<VarietyWiseReportScreen> {
  String plantName = "";
  String plantCode = "";
  String selectedDate = "";

  double earlyToday = 0;
  double generalToday = 0;
  double rejectToday = 0;
  double totalToday = 0;

  double earlyToDate = 0;
  double generalToDate = 0;
  double rejectToDate = 0;
  double totalToDate = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    /// ✅ Desktop / Web safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  Future<void> _loadAll() async {
    final sp = await SharedPreferences.getInstance();

    plantCode = sp.getString("PLANT_CODE") ?? "";
    selectedDate = sp.getString("SELECTED_DATEVAR") ?? "";

    await _loadPlantName();
    await _loadReportData();

    if (!mounted) return;
    setState(() => loading = false);
  }

  /// 🏭 Plant Name from Plant API
  Future<void> _loadPlantName() async {
    if (plantCode.isEmpty) return;

    try {
      final plants = await ApiService.fetchPlants();
      final plant = plants.firstWhere(
            (e) => e.plantCode == plantCode,
        orElse: () => PlantModel(
          plantCode: plantCode,
          plantName: "",
        ),
      );
      plantName = plant.plantName;
    } catch (e) {
      debugPrint("Plant Load Error: $e");
    }
  }

  /// 📊 Report APIs
  Future<void> _loadReportData() async {
    earlyToday =
    await ApiService.fetchVarietyTotal("EVarSumPur.php", selectedDate);
    generalToday =
    await ApiService.fetchVarietyTotal("GVarSumPur.php", selectedDate);
    rejectToday =
    await ApiService.fetchVarietyTotal("RVarSumPur.php", selectedDate);
    totalToday =
    await ApiService.fetchVarietyTotal("SumVarietyPur.php", selectedDate);

    earlyToDate =
    await ApiService.fetchVarietyTotal("EVarSumToDatePur.php", selectedDate);
    generalToDate =
    await ApiService.fetchVarietyTotal("GVarSumToDatePur.php", selectedDate);
    rejectToDate =
    await ApiService.fetchVarietyTotal("RVarSumToDatePur.php", selectedDate);
    totalToDate =
    await ApiService.fetchVarietyTotal("SumToDateVarietyPur.php", selectedDate);
  }

  String percent(double v, double t) =>
      t == 0 ? "0.00" : ((v * 100) / t).toStringAsFixed(2);

  Widget cell(String text,
      {bool bold = false, Alignment align = Alignment.center}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: TextStyle(
              fontSize: bold ? 15 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(plantName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("VARIETY WISE CRUSHING REPORT",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("DATE: $selectedDate"),
                const Divider(thickness: 2),

                Table(
                  defaultColumnWidth:
                  const IntrinsicColumnWidth(),
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    _row("SN", "CODE", "NAME", "TODAY", "%", "TODATE", "%",
                        header: true),

                    _row("1", "31", "EARLY",
                        earlyToday, percent(earlyToday, totalToday),
                        earlyToDate, percent(earlyToDate, totalToDate)),

                    _row("2", "32", "GENERAL",
                        generalToday, percent(generalToday, totalToday),
                        generalToDate, percent(generalToDate, totalToDate)),

                    _row("3", "33", "REJECT",
                        rejectToday, percent(rejectToday, totalToday),
                        rejectToDate, percent(rejectToDate, totalToDate)),

                    _row("TOTAL", "", "",
                        totalToday, "", totalToDate, "",
                        header: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _row(a, b, c, d, e, f, g, {bool header = false}) {
    final style =
    TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal);
    Widget w(x) =>
        Padding(padding: const EdgeInsets.all(6), child: Text("$x", style: style));

    return TableRow(children: [w(a), w(b), w(c), w(d), w(e), w(f), w(g)]);
  }
}
