import 'package:canemanagementsystem/screens/show_yard_data_screen.dart';
import 'package:canemanagementsystem/screens/variety_wise_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import 'LoginScreen.dart';
import 'centre_wise_date_screen.dart';
import 'graph_design_screen.dart';
import 'hourly_crushing_date_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFAEBBDA),
        body: SafeArea(
          child: Column(
            children: [
              /// 🔷 HEADER
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF608A88),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  plantName.isEmpty
                      ? "Cane Management System"
                      : plantName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 🔲 RESPONSIVE GRID
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;

                    int crossAxisCount = 2;
                    if (width > 600) crossAxisCount = 3;
                    if (width > 900) crossAxisCount = 4;

                    return GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      children: [
                        if (isAllowed(P_GRAPH))
                          dashboardItem("Inflow Analysis", Icons.bar_chart, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GraphDesign_Screen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_YARD))
                          dashboardItem("Yard Position", Icons.warehouse, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShowYardDataScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_HOURLY))
                          dashboardItem("Hourly Report", Icons.schedule, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HourlyCrushingDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_CENTRE))
                          dashboardItem("CentreWise", Icons.location_city, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CentreWiseDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_VARIETY))
                          dashboardItem("VarietyWise", Icons.agriculture, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VarietyWiseDateScreen(),
                              ),
                            );
                          }),

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
                          dashboardItem("WB Control", Icons.settings),

                        if (isAllowed(P_SCREENMASTER))
                          dashboardItem("Screen Master", Icons.dashboard_customize),

                        if (isAllowed(P_WBRANGE))
                          dashboardItem("WB Range", Icons.tune),

                        if (isAllowed(P_ROLEMASTER))
                          dashboardItem("Role Master", Icons.security),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= DASHBOARD CARD =================
  Widget dashboardItem(String title, IconData icon, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF2C4D76)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C4D76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
