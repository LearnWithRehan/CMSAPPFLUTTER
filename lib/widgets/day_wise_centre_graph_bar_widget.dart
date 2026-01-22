import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/day_wise_centre_graph_model.dart';

class DayWiseCentreGraphBarWidget extends StatelessWidget {
  final DayWiseCentreGraphModel data;

  const DayWiseCentreGraphBarWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final dayTotal =
    data.centres.fold<double>(0, (s, e) => s + e.totalCane);

    /// dynamic width for horizontal scroll
    final chartWidth = max(
      data.centres.length * 65.0,
      MediaQuery.of(context).size.width - 32,
    );

    final maxY = data.centres.map((e) => e.totalCane).reduce(max);
    final roundedMaxY = ((maxY / 500).ceil() * 500).toDouble();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 DATE
            Text(
              data.date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// 🔹 TOTAL
            Text(
              "Total : ${dayTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 HORIZONTAL SCROLL BAR CHART
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                height: 280,
                child: BarChart(
                  BarChartData(
                    maxY: roundedMaxY + (roundedMaxY * 0.1),
                    minY: 0,
                    alignment: BarChartAlignment.spaceBetween,

                    /// ❌ disable touch
                    barTouchData: BarTouchData(enabled: false),

                    /// 🔹 GRID
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: roundedMaxY / 5,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      ),
                    ),

                    /// 🔹 TITLES
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= data.centres.length) {
                              return const SizedBox();
                            }
                            return Text(
                              data.centres[index]
                                  .totalCane
                                  .toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: roundedMaxY / 5,
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
                            if (index >= data.centres.length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Transform.rotate(
                                angle: -0.7,
                                child: Text(
                                  data.centres[index].centreName,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /// 🔹 BORDER
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),

                    /// 🔹 BAR GROUPS
                    barGroups: data.centres.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barsSpace: 2,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.totalCane,
                            width: 26,
                            color: const Color(0xFF9BEAFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 LEGEND
            Row(
              children: const [
                Icon(Icons.square, size: 14, color: Color(0xFF9BEAFF)),
                SizedBox(width: 6),
                Text(
                  "Cane Weight",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
