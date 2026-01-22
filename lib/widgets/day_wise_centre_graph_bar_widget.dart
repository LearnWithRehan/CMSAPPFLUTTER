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
    double dayTotal = data.centres.fold(
        0, (sum, e) => sum + e.totalCane);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE
            Text(
              data.date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// BAR CHART
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment:
                  BarChartAlignment.spaceAround,
                  barTouchData:
                  BarTouchData(enabled: true),
                  gridData:
                  FlGridData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget:
                            (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) {
                          final index =
                          value.toInt();
                          if (index >=
                              data.centres.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 6),
                            child: Transform.rotate(
                              angle: -0.6,
                              child: Text(
                                data.centres[index]
                                    .centreName,
                                style:
                                const TextStyle(
                                    fontSize: 9),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData:
                  FlBorderData(show: false),
                  barGroups:
                  data.centres.asMap().entries.map(
                        (e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY:
                            e.value.totalCane,
                            width: 18,
                            borderRadius:
                            BorderRadius.circular(
                                4),
                            color:
                            Colors.blueAccent,
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// DAY TOTAL
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total : ${dayTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
