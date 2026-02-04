// (All your imports same — kuchh remove nahi kiya)
import 'package:canemanagementsystem/screens/role_master_screen.dart';
import 'package:canemanagementsystem/screens/screen_master_screen.dart';
import 'package:canemanagementsystem/screens/show_yard_data_screen.dart';
import 'package:canemanagementsystem/screens/variety_wise_date_screen.dart';
import 'package:canemanagementsystem/screens/village_wise_date_screen.dart';
import 'package:canemanagementsystem/screens/wb_control_screen.dart';
import 'package:canemanagementsystem/screens/wb_range_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../widgets/ip_location_service.dart';
import 'CENTREMILLGATEDATE_SCREEN.dart';
import 'GrowerLedgerScreen.dart';
import 'LoginScreen.dart';
import 'calendar_screen.dart';
import 'centre_wise_date_screen.dart';
import 'centre_wise_pur_date_screen.dart';
import 'contractor_screen.dart';
import 'create_user_screen.dart';
import 'graph_design_screen.dart';
import 'hourly_crushing_date_screen.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String locationText = "Fetching location..."; // ⭐ NEW
  String plantName = "";
  int userRole = 0;
  Set<String> permissions = {};
  String greetingMessage = "";
  String userName = ""; // ⭐ NEW
  String currentDate = "";
  String currentTime = "";
  Timer? timer;

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
  static const String GROWER_CELENDAR = "GROWER_CELENDAR";



  @override
  void initState() {
    super.initState();
    loadData();
    loadUserName();
    startClock();
    loadIpLocation();
  }

  Future<void> loadIpLocation() async {
    try {
      final loc = await IpLocationService.fetchLocation();

      setState(() {
        if (loc['city']!.isNotEmpty) {
          locationText = "${loc['city']}, ${loc['country']}";
        } else {
          locationText = "Location not available";
        }
      });
    } catch (e) {
      setState(() {
        locationText = "Location not available";
      });
    }
  }


  void startClock() {
    updateDateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    final now = DateTime.now();

    currentDate =
    "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

    currentTime =
    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void loadUserName() async {
    userName = await Prefs.getUserName();
    setState(() {});
  }

  /// 🌤 Greeting with Name
  void setGreeting() {
    final hour = DateTime.now().hour;
    String baseGreeting;

    if (hour < 12) {
      baseGreeting = "Good Morning ☀";
    } else if (hour < 17) {
      baseGreeting = "Good Afternoon 🌤";
    } else {
      baseGreeting = "Good Evening 🌙";
    }

    greetingMessage =
    userName.isNotEmpty ? "$baseGreeting, $userName" : baseGreeting;
  }

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    userRole = sp.getInt("USER_ROLE") ?? 0;
    permissions = sp.getStringList("PERMISSIONS")?.toSet() ?? {};
    userName = sp.getString("USER_NAME") ?? "Rehan"; // ⭐ change key if needed

    final plantCode = sp.getString("PLANT_CODE");
    if (plantCode != null) {
      plantName = await ApiService.fetchPlantNameByCode(plantCode);
    }

    setGreeting(); // ⭐ greeting AFTER name load
    setState(() {});
  }

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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        plantName.isEmpty ? "Cane Management System" : plantName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final sp = await SharedPreferences.getInstance();
                        await sp.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                        );
                      },
                      child: const Icon(Icons.logout, color: Colors.white),
                    )
                  ],
                ),
              ),

              /// 👋 Greeting with Name + Date & Time
              /// 👋 Greeting with Name + Date & Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingMessage,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              locationText,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(currentDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            )),
                        Text(currentTime,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            )),
                      ],
                    ),
                  ],
                ),
              ),


              /// 🎖 Role Badge
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 4, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(userRole == 1 ? "ADMIN" : "USER"),
                    backgroundColor:
                    userRole == 1 ? Colors.red : Colors.blue,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 16), color: Colors.black12),

              /// 🔲 GRID (same)
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
                        childAspectRatio: 1.0,
                      ),
                      children: [
                        if (isAllowed(P_GRAPH))
                          dashboardItem("Inflow Analysis", Icons.bar_chart, Colors.orange, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const GraphDesign_Screen()));
                          }),
                        if (isAllowed(P_YARD))
                          dashboardItem("Yard Position", Icons.warehouse, Colors.teal, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowYardDataScreen()));
                          }),
                        if (isAllowed(P_HOURLY))
                          dashboardItem("Hourly Report", Icons.schedule, Colors.purple, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const HourlyCrushingDateScreen()));
                          }),
                        if (isAllowed(P_CENTRE))
                          dashboardItem("CentreWise", Icons.location_city, Colors.blue, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CentreWiseDateScreen()));
                          }),
                        if (isAllowed(P_VARIETY))
                          dashboardItem("VarietyWise", Icons.agriculture, Colors.green, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const VarietyWiseDateScreen()));
                          }),
                        if (isAllowed(P_PAYMENT))
                          dashboardItem("CentreWise Total", Icons.summarize, Colors.indigo, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CentreWisePurDateScreen()));
                          }),
                        if (isAllowed(P_GROWER))
                          dashboardItem("Grower Ledger", Icons.person, Colors.pink, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const GrowerLedgerScreen()));
                          }),
                        if(isAllowed(GROWER_CELENDAR))
                          dashboardItem("Grower Calendar", Icons.calendar_month, Colors.yellowAccent, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
                          }),
                        if (isAllowed(P_CONTRACTOR))
                          dashboardItem("Transporter Details", Icons.local_shipping, Colors.brown, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ContractorScreen()));
                          }),
                        if (isAllowed(P_CENTREMILL))
                          dashboardItem("Centre & Mill Gate", Icons.factory, Colors.cyan, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CentreMillGateDateScreen()));
                          }),
                        if (isAllowed(P_VILLAGE))
                          dashboardItem("Village Purchase", Icons.location_on, Colors.deepOrange, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const VillageWiseDateScreen()));
                          }),
                        if (isAllowed(P_USER))
                          dashboardItem("Create User", Icons.person_add, Colors.tealAccent, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen()));
                          }),
                        if (isAllowed(P_WBCONTROL))
                          dashboardItem("WB Control", Icons.settings, Colors.grey, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const WbControlScreen()));
                          }),
                        if (isAllowed(P_SCREENMASTER))
                          dashboardItem("Screen Master", Icons.dashboard_customize, Colors.blueGrey, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ScreenMasterScreen()));
                          }),
                        if (isAllowed(P_WBRANGE))
                          dashboardItem("WB Range", Icons.tune, Colors.deepPurple, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const WbRangeScreen()));
                          }),
                        if (isAllowed(P_ROLEMASTER))
                          dashboardItem("Role Master", Icons.security, Colors.amber, () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleMasterScreen()));
                          }),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("Version 1.0.0",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardItem(String title, IconData icon, Color bgColor, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
