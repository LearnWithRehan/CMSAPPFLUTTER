import 'package:canemanagementsystem/screens/VarietyWiseGraphScreen.dart';
import 'package:canemanagementsystem/screens/centre_wise_total_cane_graph_screen.dart';
import 'package:flutter/material.dart';
import 'cane_trend_graph_screen.dart';
import 'centre_wise_cane_trend_screen.dart';

class GraphDesign_Screen extends StatelessWidget {
  const GraphDesign_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          "Cane Arrival Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ✅ DAY WISE → OPEN CaneTrendGraphScreen
            _reportCard(
              title: "Day Wise Cane Arrival",
              subtitle: "Daily cane arrival trend graph",
              iconColor: Colors.green,
              borderColor: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CaneTrendGraphScreen(),
                  ),
                );
              },
            ),

            _reportCard(
              title: "Centre Wise Cane Purchase",
              subtitle: "Centre wise daily cane analysis",
              iconColor: const Color(0xFFE89309),
              borderColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DayWiseCentreGraphScreen(),
                  ),
                );
              },
            ),


            _reportCard(
              title: "Centre Wise Total Cane Pur",
              subtitle: "Centre wise Total cane analysis",
              iconColor: Colors.blue,
              borderColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CentreWiseTotalCaneGraphScreen(),
                  ),
                );
              },
            ),

            _reportCard(
              title: "Day Wise Variety Cane Pur",
              subtitle: "Daily cane arrival analysis by variety",
              iconColor: Colors.red,
              borderColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VarietyWiseGraphScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= REPORT CARD =================
  Widget _reportCard({
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.bar_chart,
                size: 48,
                color: iconColor,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
