import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
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

  /// 🔹 Load Plant Name using Plant Code
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

  /// ▶️ Process Button
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

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 🔷 HEADER
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          /// 🏭 PLANT NAME
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

                          /// 📊 REPORT TITLE
                          Text(
                            "Hourly Crushing Report",
                            style: TextStyle(
                              fontSize: isWeb ? 26 : 22,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Divider(height: 30),

                          /// LABEL
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

                          /// DATE PICKER
                          InkWell(
                            onTap: pickDate,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 48,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// ▶️ PROCESS BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onProcess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C4D76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        "PROCESS",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }
}
