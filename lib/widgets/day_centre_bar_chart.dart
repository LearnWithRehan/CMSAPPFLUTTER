import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/day_wise_data.dart';

class DayCentreBarChart extends StatelessWidget {
  final DayWiseData dayData;

  const DayCentreBarChart({super.key, required this.dayData});

  @override
  Widget build(BuildContext context) {
    double dayTotal = dayData.centres.fold(
        0, (sum, e) => sum + e.totalCane);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DATE
            Text(
              dayData.date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            // BAR CHART
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  barGroups: _buildBars(),
                  titlesData: _titles(),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                  alignment: BarChartAlignment.spaceAround,
                ),
              ),
            ),

            // TOTAL
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total : ${dayTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    return List.generate(dayData.centres.length, (index) {
      final value = dayData.centres[index].totalCane;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 18,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  FlTitlesData _titles() {
    return FlTitlesData(
      rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(value.toInt().toString(),
                style: const TextStyle(fontSize: 10));
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= dayData.centres.length) return const SizedBox();
            return Transform.rotate(
              angle: -0.7,
              child: Text(
                dayData.centres[index].centreName,
                style: const TextStyle(fontSize: 9),
              ),
            );
          },
        ),
      ),
    );
  }
}
