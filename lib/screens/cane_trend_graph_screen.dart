import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../models/cane_day_data.dart';

class CaneTrendGraphScreen extends StatefulWidget {
  const CaneTrendGraphScreen({super.key});

  @override
  State<CaneTrendGraphScreen> createState() => _CaneTrendGraphScreenState();
}

class _CaneTrendGraphScreenState extends State<CaneTrendGraphScreen> {
  List<CaneDayData> graphData = [];
  double grandTotal = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final plantCode = sp.getString("PLANT_CODE") ?? "";

      if (plantCode.isEmpty) return;

      graphData = await ApiService.fetchCaneTrend(plantCode);
      grandTotal = await ApiService.fetchGrandTotal(plantCode);
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Day Wise Cane Arrival Trend"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔹 TOTAL PURCHASE
            Text(
              "Todate Purchase : ${grandTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 LINE CHART
            Expanded(child: buildChart()),
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    // calculate width: har ek date ke liye 60px, min 300px
    final chartWidth = ((graphData.length * 60).toDouble().clamp(300, double.infinity)) as double;


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        child: LineChart(
          LineChartData(
            minY: 0,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < graphData.length) {
                      return Transform.rotate(
                        angle: -0.8, // rotate for better fit
                        child: Text(
                          graphData[index].date,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const Text("");
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: graphData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(
                  e.key.toDouble(),
                  e.value.totalCane.toDouble(), // ✅ convert to double
                ))
                    .toList(),
                isCurved: true,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}
