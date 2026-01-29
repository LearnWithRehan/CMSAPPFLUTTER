import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/plant_model.dart';
import 'village_wise_screen.dart';

class VillageWiseDateScreen extends StatefulWidget {
  const VillageWiseDateScreen({super.key});

  @override
  State<VillageWiseDateScreen> createState() =>
      _VillageWiseDateScreenState();
}

class _VillageWiseDateScreenState extends State<VillageWiseDateScreen> {
  DateTime selectedDate = DateTime.now();

  String plantCode = "";
  String plantName = "";

  @override
  void initState() {
    super.initState();
    _loadPlantName();
  }

  /// 🌱 Load Plant Name using PLANT_CODE
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
      debugPrint("Plant Load Error: $e");
    }
  }

  /// 📅 Date Format
  String get formattedDate =>
      DateFormat("dd-MM-yyyy").format(selectedDate);

  /// 📆 Date Picker
  Future<void> _openDatePicker() async {
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
  Future<void> _onProcess() async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString("SELECTED_DATEVILLAGE", formattedDate);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VillageWiseScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Village Wise Date"),
        backgroundColor: const Color(0xFF2C4D76),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔷 HEADER CARD
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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

                        /// TITLE
                        const Text(
                          "VILLAGE WISE REPORT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Divider(height: 30),

                        /// LABEL
                        const Text(
                          "Select Date",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// DATE PICKER
                        InkWell(
                          onTap: _openDatePicker,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 22,
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

                const SizedBox(height: 20),

                /// ▶️ PROCESS BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _onProcess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C4D76),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "PROCESS",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
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
    );
  }
}
