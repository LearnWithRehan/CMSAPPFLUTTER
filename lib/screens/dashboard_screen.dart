import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  /// ✅ YAHAN DECLARE
  String plantName = "";

  @override
  void initState() {
    super.initState();
    loadPlantName();
  }

  /// ✅ API + SharedPreferences
  Future<void> loadPlantName() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final plantCode = sp.getString("PLANT_CODE") ?? "";

      if (plantCode.isEmpty) return;

      final name =
      await ApiService.fetchPlantNameByCode(plantCode);

      setState(() {
        plantName = name;
      });
    } catch (e) {
      debugPrint("Plant Name Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAEBBDA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔷 HEADER
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 16),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF608A88),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  plantName.isEmpty
                      ? "Cane Management System"
                      : plantName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 🔲 GRID MENU
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [

                  dashboardItem(icon: Icons.bar_chart, title: "Inflow Analysis"),
                  dashboardItem(icon: Icons.warehouse, title: "Yard Position"),
                  dashboardItem(icon: Icons.schedule, title: "Hourly Report"),
                  dashboardItem(icon: Icons.location_city, title: "CentreWise"),
                  dashboardItem(icon: Icons.agriculture, title: "VarietyWise"),
                  dashboardItem(icon: Icons.summarize, title: "CentreWise Total"),
                  dashboardItem(icon: Icons.person, title: "Grower Ledger"),
                  dashboardItem(icon: Icons.local_shipping, title: "Transporter Details"),
                  dashboardItem(icon: Icons.factory, title: "Centre & Mill Gate"),
                  dashboardItem(icon: Icons.location_on, title: "Village Purchase"),
                  dashboardItem(icon: Icons.person_add, title: "Create User"),
                  dashboardItem(icon: Icons.settings, title: "WB CONTROL"),
                  dashboardItem(icon: Icons.dashboard_customize, title: "SCREEN MASTER"),
                  dashboardItem(icon: Icons.tune, title: "WB RANGE"),
                  dashboardItem(icon: Icons.security, title: "ROLE MASTER"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 CARD ITEM
  Widget dashboardItem({
    required IconData icon,
    required String title,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF2C4D76)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C4D76),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
