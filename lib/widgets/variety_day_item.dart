import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/variety_day_data.dart';

class VarietyDayItem extends StatelessWidget {
  final VarietyDayData item;

  const VarietyDayItem({super.key, required this.item});

  String f(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final total = item.early + item.general + item.reject;

    final earlyPer = total == 0 ? 0 : (item.early * 100) / total;
    final generalPer = total == 0 ? 0 : (item.general * 100) / total;
    final rejectPer = total == 0 ? 0 : (item.reject * 100) / total;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// DATE
            Text(
              item.date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// TOTAL
            Text(
              "Total : ${f(total)}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            /// GRAPH
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: total * 1.3,
                  alignment: BarChartAlignment.spaceAround,

                  /// 🔥 TOOLTIP (VALUE + %)
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 6,
                      getTooltipItem:
                          (group, groupIndex, rod, rodIndex) {
                        double? percent = 0;

                        if (group.x == 0) {
                          percent = earlyPer as double?;
                        } else if (group.x == 1) {
                          percent = generalPer as double?;
                        } else {
                          percent = rejectPer as double?;
                        }

                        return BarTooltipItem(
                          "${rod.toY.toStringAsFixed(2)} (${percent?.toStringAsFixed(2)}%)",
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
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
                        interval: total / 5,
                        getTitlesWidget: (v, m) => Text(
                          v.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          switch (v.toInt()) {
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

                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),

                  barGroups: [
                    _bar(0, item.early, Colors.green),
                    _bar(1, item.general, Colors.blue),
                    _bar(2, item.reject, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: const [0],
      barRods: [
        BarChartRodData(
          toY: value,
          width: 28,
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
      ],
    );
  }
}
