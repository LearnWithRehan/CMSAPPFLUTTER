import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import 'dashboard_screen.dart';
import 'hourly_crushing_report_screen.dart';
import 'hourly_report_two_to_two_screen.dart';
import '../models/plant_model.dart';

class HourlyCrushingDateScreen extends StatefulWidget {
  const HourlyCrushingDateScreen({super.key});

  @override
  State<HourlyCrushingDateScreen> createState() =>
      _HourlyCrushingDateScreenState();
}

class _HourlyCrushingDateScreenState extends State<HourlyCrushingDateScreen> {
  late DateTime selectedDate;

  String plantName = "";
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    loadPlantName();
  }

  /// 🔙 GO TO DASHBOARD (COMMON)
  void _goToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
    );
  }

  /// 🏭 Load Plant Name
  Future<void> loadPlantName() async {
    final sp = await SharedPreferences.getInstance();
    plantCode = sp.getString("PLANT_CODE") ?? "";

    if (plantCode.isEmpty) return;

    try {
      final plants = await ApiService.fetchPlants();
      final plant = plants.firstWhere(
            (e) => e.plantCode == plantCode,
        orElse: () => PlantModel(
          plantCode: plantCode,
          plantName: "",
        ),
      );

      setState(() {
        plantName = plant.plantName;
      });
    } catch (e) {
      debugPrint("Plant Load Error: $e");
    }
  }

  /// 📅 Date Format
  String get formattedDate =>
      DateFormat('dd-MM-yyyy').format(selectedDate);

  /// 📆 Date Picker
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// ▶️ PROCESS
  Future<void> onProcess() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString("SELECTED_DATEHOURLY", formattedDate);

    if (plantCode == "105" || plantCode == "104") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HourlyReportTwoToTwoScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HourlyCrushingReportScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 600;

    return WillPopScope(
      onWillPop: () async {
        _goToDashboard();
        return false; // ❗ app close hone se rokta hai
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),

        /// 🔝 APP BAR WITH BACK
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C4D76),
          title: const Text("Hourly Crushing Report"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goToDashboard,
          ),
        ),

        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🔷 HEADER CARD
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          children: [

                            if (plantName.isNotEmpty)
                              Text(
                                plantName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isWeb ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2C4D76),
                                ),
                              ),

                            const SizedBox(height: 6),

                            Text(
                              "Hourly Crushing Report",
                              style: TextStyle(
                                fontSize: isWeb ? 26 : 22,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const Divider(height: 30),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select Date",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            InkWell(
                              onTap: pickDate,
                              child: Container(
                                height: 48,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.shade400),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 20),
                                    const SizedBox(width: 12),
                                    Text(formattedDate),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C4D76),
                        ),
                        child: const Text(
                          "PROCESS",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
