import 'dart:math';
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
            // Total Purchase
            Text(
              "Todate Purchase: ${grandTotal.toStringAsFixed(2)} Qt",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: buildChart()),
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    if (graphData.isEmpty) return const Center(child: Text("No Data"));

    final maxY = graphData.map((e) => e.totalCane.toDouble()).reduce(max);
    final roundedMaxY = ((maxY / 5000).ceil() * 5000).toDouble();
    final chartWidth =
    max(graphData.length * 100.0, MediaQuery.of(context).size.width);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        child: Stack(
          children: [
            // ------------------ LineChart ------------------
            LineChart(
              LineChartData(
                minY: 0,
                maxY: roundedMaxY,
               // prevent clipping at edges
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: roundedMaxY / 6,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: roundedMaxY / 6,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= graphData.length) return const SizedBox.shrink();

                        // Add left/right padding for first & last
                        EdgeInsets padding = EdgeInsets.zero;
                        if (index == 0) padding = const EdgeInsets.only(left: 20);
                        if (index == graphData.length - 1)
                          padding = const EdgeInsets.only(right: 20);

                        return Padding(
                          padding: padding.add(const EdgeInsets.only(top: 8)),
                          child: Transform.rotate(
                            angle: -0.7,
                            child: Text(
                              graphData[index].date,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.black.withOpacity(0.6)),
                    bottom: BorderSide(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.cyanAccent.shade700,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    spots: graphData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                        e.key.toDouble(), e.value.totalCane.toDouble()))
                        .toList(),
                  ),
                ],
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),

            // ------------------ Overlay values above dots ------------------
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chartHeight = constraints.maxHeight;
                  final chartWidthActual = chartWidth;

                  return Stack(
                    children: graphData.asMap().entries.map((e) {
                      // X position adjustment for first and last dots
                      double x =
                          e.key.toDouble() / (graphData.length - 1) * chartWidthActual;
                      if (e.key == 0) x += 20;
                      if (e.key == graphData.length - 1) x -= 20;

                      final y =
                          chartHeight - (e.value.totalCane.toDouble() / roundedMaxY * chartHeight);

                      return Positioned(
                        left: x - 20,
                        top: y - 28,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1))
                            ],
                          ),
                          child: Text(
                            e.value.totalCane.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
