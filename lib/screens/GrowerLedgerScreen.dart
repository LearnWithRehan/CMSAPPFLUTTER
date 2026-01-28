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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GrowerLedgerDetailsScreen(
          villageGrower: "$village/$grower",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grower Ledger"),
        backgroundColor: const Color(0xFF2C4D76),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // ✅ Max width for desktop/tablet
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 🏭 PLANT NAME
                    Text(
                      plantName.isEmpty ? "Loading..." : plantName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C4D76),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 1),
                    const SizedBox(height: 20),

                    /// 📄 TITLE
                    const Text(
                      "GROWER PAID / UNPAID DETAILS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _rowField("VILLAGE", villageController),
                    const SizedBox(height: 20),
                    _rowField("GROWER", growerController),

                    const SizedBox(height: 32),

                    /// ▶️ BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onShow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C4D76),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "SHOW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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

  Widget _rowField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Enter here",
            ),
          ),
        ),
      ],
    );
  }
}
