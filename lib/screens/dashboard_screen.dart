import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import 'LoginScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  /// ================= DATA =================
  String plantName = "";
  int userRole = 0;
  Set<String> permissions = {};

  /// ================= PERMISSION KEYS =================
  static const String P_YARD = "YARD_POSITION";
  static const String P_HOURLY = "HOURLY_REPORT";
  static const String P_CENTRE = "CENTRE_WISE";
  static const String P_VARIETY = "VARIETY_WISE";
  static const String P_PAYMENT = "CENTRE_WISE_TOTAL";
  static const String P_GROWER = "GROWER_LEDGER";
  static const String P_CONTRACTOR = "CONTRACTOR";
  static const String P_USER = "CREATEUSER";
  static const String P_WBCONTROL = "WBCONTROL";
  static const String P_SCREENMASTER = "SCREEN_MASTER";
  static const String P_WBRANGE = "WBRANGE";
  static const String P_ROLEMASTER = "ROLEMASTER";
  static const String P_CENTREMILL = "CENTREMILLGATE";
  static const String P_VILLAGE = "VILLAGEWISE";
  static const String P_GRAPH = "GRAPHWISE";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// ================= LOAD PREF + API =================
  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();

    userRole = sp.getInt("USER_ROLE") ?? 0;
    permissions = sp.getStringList("PERMISSIONS")?.toSet() ?? {};

    final plantCode = sp.getString("PLANT_CODE");
    if (plantCode != null) {
      plantName = await ApiService.fetchPlantNameByCode(plantCode);
    }

    setState(() {});
  }

  /// ================= PERMISSION CHECK =================
  bool isAllowed(String permission) {
    return userRole == 1 || permissions.contains(permission);
  }

  /// ================= NAVIGATION CHECK =================
  void openIfAllowed(String permission, Widget screen) {
    if (isAllowed(permission)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission Denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// 🔴 BACK PRESS → LOGIN SCREEN (Java onBackPressed)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
        return false; // app close hone se roke
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFAEBBDA),
        body: SafeArea(
          child: Column(
            children: [

              /// 🔷 FIXED HEADER
              Container(
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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

              /// 🔲 ONLY GRID SCROLLS
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [

                      if (isAllowed(P_GRAPH))
                        dashboardItem("Inflow Analysis", Icons.bar_chart),

                      if (isAllowed(P_YARD))
                        dashboardItem("Yard Position", Icons.warehouse),

                      if (isAllowed(P_HOURLY))
                        dashboardItem("Hourly Report", Icons.schedule),

                      if (isAllowed(P_CENTRE))
                        dashboardItem("CentreWise", Icons.location_city),

                      if (isAllowed(P_VARIETY))
                        dashboardItem("VarietyWise", Icons.agriculture),

                      if (isAllowed(P_PAYMENT))
                        dashboardItem("CentreWise Total", Icons.summarize),

                      if (isAllowed(P_GROWER))
                        dashboardItem("Grower Ledger", Icons.person),

                      if (isAllowed(P_CONTRACTOR))
                        dashboardItem("Transporter Details", Icons.local_shipping),

                      if (isAllowed(P_CENTREMILL))
                        dashboardItem("Centre & Mill Gate", Icons.factory),

                      if (isAllowed(P_VILLAGE))
                        dashboardItem("Village Purchase", Icons.location_on),

                      if (isAllowed(P_USER))
                        dashboardItem("Create User", Icons.person_add),

                      if (isAllowed(P_WBCONTROL))
                        dashboardItem("WB CONTROL", Icons.settings),

                      if (isAllowed(P_SCREENMASTER))
                        dashboardItem("SCREEN MASTER", Icons.dashboard_customize),

                      if (isAllowed(P_WBRANGE))
                        dashboardItem("WB RANGE", Icons.tune),

                      if (isAllowed(P_ROLEMASTER))
                        dashboardItem("ROLE MASTER", Icons.security),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= CARD =================
  Widget dashboardItem(String title, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
