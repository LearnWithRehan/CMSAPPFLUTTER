import 'package:canemanagementsystem/screens/screen_master_screen.dart';
import 'package:canemanagementsystem/screens/show_yard_data_screen.dart';
import 'package:canemanagementsystem/screens/variety_wise_date_screen.dart';
import 'package:canemanagementsystem/screens/village_wise_date_screen.dart';
import 'package:canemanagementsystem/screens/wb_control_screen.dart';
import 'package:canemanagementsystem/screens/wb_range_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import 'CENTREMILLGATEDATE_SCREEN.dart';
import 'GrowerLedgerScreen.dart';
import 'LoginScreen.dart';
import 'centre_wise_date_screen.dart';
import 'centre_wise_pur_date_screen.dart';
import 'contractor_screen.dart';
import 'create_user_screen.dart';
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
        backgroundColor: const Color(0xFFE8ECF4),
        body: SafeArea(
          child: Column(
            children: [
              /// 🔷 HEADER
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C4D76),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Text(
                  plantName.isEmpty
                      ? "Cane Management System"
                      : plantName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                        childAspectRatio: 1.0, // smaller, compact cards
                      ),
                      children: [
                        if (isAllowed(P_GRAPH))
                          dashboardItem("Inflow Analysis", Icons.bar_chart, Colors.orange, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GraphDesign_Screen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_YARD))
                          dashboardItem("Yard Position", Icons.warehouse, Colors.teal, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShowYardDataScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_HOURLY))
                          dashboardItem("Hourly Report", Icons.schedule, Colors.purple, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HourlyCrushingDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_CENTRE))
                          dashboardItem("CentreWise", Icons.location_city, Colors.blue, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CentreWiseDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_VARIETY))
                          dashboardItem("VarietyWise", Icons.agriculture, Colors.green, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VarietyWiseDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_PAYMENT))
                          dashboardItem("CentreWise Total", Icons.summarize, Colors.indigo, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CentreWisePurDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_GROWER))
                          dashboardItem("Grower Ledger", Icons.person, Colors.pink, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GrowerLedgerScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_CONTRACTOR))
                          dashboardItem("Transporter Details", Icons.local_shipping, Colors.brown, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ContractorScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_CENTREMILL))
                          dashboardItem("Centre & Mill Gate", Icons.factory, Colors.cyan, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CentreMillGateDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_VILLAGE))
                          dashboardItem("Village Purchase", Icons.location_on, Colors.deepOrange, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VillageWiseDateScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_USER))
                          dashboardItem("Create User", Icons.person_add, Colors.tealAccent, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateUserScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_WBCONTROL))
                          dashboardItem("WB Control", Icons.settings, Colors.grey, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WbControlScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_SCREENMASTER))
                          dashboardItem("Screen Master", Icons.dashboard_customize, Colors.blueGrey, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ScreenMasterScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_WBRANGE))
                          dashboardItem("WB Range", Icons.tune, Colors.deepPurple, (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WbRangeScreen(),
                              ),
                            );
                          }),

                        if (isAllowed(P_ROLEMASTER))
                          dashboardItem("Role Master", Icons.security, Colors.amber),
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
  Widget dashboardItem(String title, IconData icon, Color bgColor, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor.withOpacity(0.7), bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
