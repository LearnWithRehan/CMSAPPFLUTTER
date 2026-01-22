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
          crossAxisAlignment: CrossAxisAlignment.start,
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
    // har ek date ke liye 60px, minimum 300px
    final chartWidth = ((graphData.length * 60).toDouble().clamp(300.0, double.infinity));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0), // left-right padding
        child: SizedBox(
          width: chartWidth,
          child: LineChart(
            LineChartData(
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 50,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < graphData.length) {
                        return Transform.rotate(
                          angle: -0.8, // rotate for better fit
                          child: Text(
                            graphData[index].date,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: (grandTotal / 5).ceilToDouble(), // dynamic interval
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: graphData
                      .asMap()
                      .entries
                      .map((e) => FlSpot(
                    e.key.toDouble(),
                    e.value.totalCane.toDouble(),
                  ))
                      .toList(),
                  isCurved: true,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
