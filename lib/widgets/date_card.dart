import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/centre_day_item.dart';

class DateCard extends StatelessWidget {
  final String date;
  final List<CentreDayItem> list;

  const DateCard({
    super.key,
    required this.date,
    required this.list,
  });

  double get dayTotal =>
      list.fold(0.0, (s, e) => s + e.total);

  @override
  Widget build(BuildContext context) {
    final barCount = list.length * 9;
    final chartWidth = barCount * 45.0;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Total : ${dayTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                height: 320,
                child: BarChart(barData()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData barData() {
    int x = 0;
    final bars = <BarChartGroupData>[];
    final labels = <int, String>{};
    final isCentreLabel = <int, bool>{};

    for (var item in list) {
      /// CENTRE NAME (NO VALUE)
      labels[x] = item.cnName;
      isCentreLabel[x] = true;
      bars.add(_bar(x, 0, Colors.transparent, showValue: false));
      x += 2;

      labels[x] = "Early";
      bars.add(_bar(x, item.early, Colors.blue.shade600));
      x += 2;

      labels[x] = "General";
      bars.add(_bar(x, item.general, Colors.green.shade600));
      x += 2;

      labels[x] = "Reject";
      bars.add(_bar(x, item.reject, Colors.red.shade600));
      x += 2;

      labels[x] = "Total";
      bars.add(_bar(x, item.total, Colors.orange.shade700));
      x += 3;
    }

    return BarChartData(
      barGroups: bars,
      alignment: BarChartAlignment.start,
      maxY: _maxY() * 1.6,

      /// VALUE ALWAYS VISIBLE
      barTouchData: BarTouchData(
        enabled: false, // 👈 static value only
        touchTooltipData: BarTouchTooltipData(
          tooltipMargin: 6,
          tooltipPadding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            if (rod.toY == 0) return null;
            return BarTooltipItem(
              rod.toY.toStringAsFixed(2),
              const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),

      gridData: FlGridData(
        show: true,
        horizontalInterval: _maxY() / 4,
        getDrawingHorizontalLine: (v) => FlLine(
          color: Colors.grey.shade300,
          strokeWidth: 1,
        ),
      ),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        topTitles:
        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 46,
            interval: _maxY() / 4,
            getTitlesWidget: (v, meta) => Text(
              v.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 95,
            getTitlesWidget: (value, meta) {
              final text = labels[value.toInt()] ?? "";
              final isCentre = isCentreLabel[value.toInt()] == true;

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Transform.rotate(
                  angle: -0.55,
                  child: SizedBox(
                    width: 80,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                        isCentre ? FontWeight.bold : FontWeight.w500,
                        color: isCentre
                            ? Colors.black
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(
      int x,
      double y,
      Color c, {
        bool showValue = true,
      }) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showValue && y > 0 ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y,
          width: 14,
          color: c,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  double _maxY() {
    double m = 0;
    for (var e in list) {
      m = [
        m,
        e.early,
        e.general,
        e.reject,
        e.total,
      ].reduce((a, b) => a > b ? a : b);
    }
    return m == 0 ? 10 : m;
  }
}
