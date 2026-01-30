import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/variety_day_data.dart';

class VarietyDayItem extends StatelessWidget {
  final VarietyDayData item;

  const VarietyDayItem({super.key, required this.item});

  String f(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final double total = item.early + item.general + item.reject;

    final double earlyPer = total == 0 ? 0.0 : (item.early * 100.0) / total;
    final double generalPer = total == 0 ? 0.0 : (item.general * 100.0) / total;
    final double rejectPer = total == 0 ? 0.0 : (item.reject * 100.0) / total;

    final double maxY = _roundUp(total);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(item.date,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),

            const SizedBox(height: 4),

            Text("Total : ${f(total)}",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),

            const SizedBox(height: 12),

            Container(
              height: 230,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xfff4f6f8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: maxY,
                  alignment: BarChartAlignment.spaceEvenly,

                  /// 🔥 TOOLTIP ENABLED
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final value = rod.toY;
                        final percent =
                        total == 0 ? 0 : (value * 100) / total;

                        return BarTooltipItem(
                          '${value.toStringAsFixed(1)}\n(${percent.toStringAsFixed(1)}%)',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: maxY / 4,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Early");
                            case 1:
                              return const Text("General");
                            case 2:
                              return const Text("Reject");
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),

                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.black12,
                      strokeWidth: 1,
                    ),
                  ),

                  borderData: FlBorderData(show: false),

                  barGroups: [
                    _bar(0, item.early, Colors.green),
                    _bar(1, item.general, Colors.blue),
                    _bar(2, item.reject, Colors.red),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _Legend(color: Colors.green, text: "Early"),
                SizedBox(width: 14),
                _Legend(color: Colors.blue, text: "General"),
                SizedBox(width: 14),
                _Legend(color: Colors.red, text: "Reject"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 BAR WITH ALWAYS VISIBLE LABEL
  BarChartGroupData _bar(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: const [0],
      barRods: [
        BarChartRodData(
          toY: value,
          width: 35,
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  double _roundUp(double value) {
    if (value <= 0) return 100;
    return (value / 1000).ceil() * 1000;
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
