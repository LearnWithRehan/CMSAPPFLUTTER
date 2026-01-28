import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/plant_model.dart';
import 'GrowerLedgerDetailsScreen.dart';

class GrowerLedgerScreen extends StatefulWidget {
  const GrowerLedgerScreen({super.key});

  @override
  State<GrowerLedgerScreen> createState() => _GrowerLedgerScreenState();
}

class _GrowerLedgerScreenState extends State<GrowerLedgerScreen> {
  final TextEditingController villageController = TextEditingController();
  final TextEditingController growerController = TextEditingController();

  String plantName = "";
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    _loadPlant();
  }

  // ================= LOAD PLANT =================

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
          plantName: "Unknown Plant",
        ),
      );

      if (mounted) {
        setState(() {
          plantName = plant.plantName;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          plantName = "Server Error";
        });
      }
    }
  }

  // ================= SHOW BUTTON =================

  void _onShow() {
    final village = villageController.text.trim();
    final grower = growerController.text.trim();

    if (village.isEmpty || grower.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Village aur Grower code enter karo")),
      );
      return;
    }

    if (plantCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Plant code not found. Please login again")),
      );
      return;
    }

    /// ✅ NEW NAVIGATION (ONLY ONE PARAM)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GrowerLedgerDetailsScreen(
          villageGrower: "$village/$grower", // 👈 "111/25"
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C4D76), Color(0xFF6FA8DC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🏭 PLANT NAME
                Text(
                  plantName.isEmpty ? "Loading..." : plantName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 20),

                /// 📄 TITLE
                const Text(
                  "GROWER PAID / UNPAID DETAILS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                _rowField("VILLAGE", villageController),
                const SizedBox(height: 18),
                _rowField("GROWER", growerController),

                const SizedBox(height: 32),

                /// ▶️ BUTTON
                ElevatedButton(
                  onPressed: _onShow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "SHOW",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  // ================= INPUT ROW =================

  Widget _rowField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
