import 'package:canemanagementsystem/screens/yard_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/plant_model.dart';

class ShowYardDataScreen extends StatefulWidget {
  const ShowYardDataScreen({Key? key}) : super(key: key);

  @override
  State<ShowYardDataScreen> createState() => _ShowYardDataScreenState();
}

class _ShowYardDataScreenState extends State<ShowYardDataScreen> {
  String selectedDate = "";
  String plantName = "";
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    _setTodayDate();
    _loadPlantName();
  }

  /// 🌱 Load Plant Name (same logic as CentreWiseDateScreen)
  Future<void> _loadPlantName() async {
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
      debugPrint("Plant load error: $e");
    }
  }

  /// 📅 Set today's date
  void _setTodayDate() {
    final now = DateTime.now();
    selectedDate = DateFormat("dd-MM-yyyy").format(now);
  }

  /// 📆 Open Date Picker
  Future<void> _openDatePicker() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
      setState(() {});
    }
  }

  /// ▶️ Process Button
  Future<void> _onProcess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("SELECTED_DATE", selectedDate);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const YardPositionScreen(),
      ),
    );
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
            child: SingleChildScrollView(
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

                          /// 📊 TITLE
                          Text(
                            "Yard Report",
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
                            onTap: _openDatePicker,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 48,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                Border.all(color: Colors.grey.shade400),
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
                                    selectedDate,
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
                      onPressed: _onProcess,
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
    );
  }
}
