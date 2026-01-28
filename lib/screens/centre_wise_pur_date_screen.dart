import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/plant_model.dart';
import 'CenterWiseReportScreenKudiyaPurchase.dart';
import 'CentreWiseReportPurchaseScreen.dart';


class CentreWisePurDateScreen extends StatefulWidget {
  const CentreWisePurDateScreen({super.key});

  @override
  State<CentreWisePurDateScreen> createState() =>
      _CentreWisePurDateScreenState();
}

class _CentreWisePurDateScreenState extends State<CentreWisePurDateScreen> {
  DateTime selectedDate = DateTime.now();

  String plantName = "";
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    _loadPlant();
  }

  /// 🏭 Load Plant Name & Code
  Future<void> _loadPlant() async {
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

  /// 📅 Formatted Date (dd-MM-yyyy)
  String get formattedDate =>
      DateFormat('dd-MM-yyyy').format(selectedDate);

  /// 📆 Open Date Picker
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  /// ▶️ PROCESS BUTTON
  Future<void> onProcess() async {
    final sp = await SharedPreferences.getInstance();

    // Save Selected Date
    await sp.setString("SELECTED_DATECNT", formattedDate);

    // Navigation same as Java
    if (plantCode == "101") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CentreWiseReportPurchaseScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const CentreWiseReportPurchaseScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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

                          /// 📊 TITLE
                          Text(
                            "Centre Wise Report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isWeb ? 30 : 26,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// LABEL
                          const Text(
                            "Select Date",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// 📅 DATE PICKER BOX
                          InkWell(
                            onTap: pickDate,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
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
                    height: 55,
                    child: ElevatedButton(
                      onPressed: onProcess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C4D76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
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
