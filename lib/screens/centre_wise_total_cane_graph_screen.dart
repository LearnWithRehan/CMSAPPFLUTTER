import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/centre_wise_total_cane_model.dart';
import '../core/api/api_service.dart';

class CentreWiseTotalCaneGraphScreen extends StatefulWidget {
  const CentreWiseTotalCaneGraphScreen({super.key});

  @override
  State<CentreWiseTotalCaneGraphScreen> createState() =>
      _CentreWiseTotalCaneGraphScreenState();
}

class _CentreWiseTotalCaneGraphScreenState
    extends State<CentreWiseTotalCaneGraphScreen> {

  List<CentreWiseTotalCaneModel> list = [];
  bool isLoading = true;
  double grandTotal = 0;

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

      final data =
      await ApiService.fetchCentreWiseTotalCane(plantCode);

      double total = 0;
      for (var e in data) {
        total += e.totalCane;
      }

      setState(() {
        list = data;
        grandTotal = total;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxY =
    list.isEmpty ? 0 : list.map((e) => e.totalCane).reduce(max);

    final chartWidth = max(
      list.length * 80.0, // 🔥 per bar width (scroll control)
      MediaQuery.of(context).size.width,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Centre Wise Total Cane Purchase"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= GRAPH =================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    height: 420,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: maxY * 1.15, // 🔥 TOP SPACE (CUT FIX)

                        alignment: BarChartAlignment.spaceBetween,

                        /// 🔥 VALUE ON TOP (ALWAYS VISIBLE)
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 6,
                            getTooltipItem:
                                (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rod.toY.toStringAsFixed(2), // EXACT
                                const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),

                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 48,
                              interval: maxY / 5,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= list.length) {
                                  return const SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Transform.rotate(
                                    angle: -0.7,
                                    child: Text(
                                      list[index].centreName,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 5,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
                        ),

                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left:
                            BorderSide(color: Colors.grey.shade400),
                            bottom:
                            BorderSide(color: Colors.grey.shade400),
                          ),
                        ),

                        barGroups: List.generate(
                          list.length,
                              (index) {
                            return BarChartGroupData(
                              x: index,
                              showingTooltipIndicators: const [0],
                              barRods: [
                                BarChartRodData(
                                  toY: list[index].totalCane,
                                  width: 28,
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFF9BEAFF),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ================= TOTAL =================
                Text(
                  "Total (All Centres) : ${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
