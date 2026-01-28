import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/contractor_model.dart';
import '../models/plant_model.dart';
import 'contractor_details_screen.dart';
import 'dashboard_screen.dart';

class ContractorScreen extends StatefulWidget {
  const ContractorScreen({super.key});

  @override
  State<ContractorScreen> createState() => _ContractorScreenState();
}

class _ContractorScreenState extends State<ContractorScreen> {
  DateTime fromDate = DateTime.now();
  DateTime tillDate = DateTime.now();

  List<ContractorModel> contractors = [];
  ContractorModel? selectedContractor;

  bool loading = true;

  String plantName = "";
  String plantCode = "";

  final df = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    super.initState();
    loadPlantName();
    loadContractors();
  }

  /// 🏭 LOAD PLANT NAME (Same as VarietyWise)
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
      debugPrint("Plant load error: $e");
    }
  }

  /// 👷 LOAD CONTRACTORS
  Future<void> loadContractors() async {
    try {
      contractors = await ApiService.getContractorList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  /// 📅 DATE PICKER
  Future<void> pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : tillDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        isFrom ? fromDate = picked : tillDate = picked;
      });
    }
  }

  /// 🔙 BACK TO DASHBOARD
  void goToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 600;

    return WillPopScope(
      onWillPop: () async {
        goToDashboard();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        /// 🔷 APPBAR
        appBar: AppBar(
          title: const Text("Contractor Report"),
          backgroundColor: const Color(0xFF2C4D76),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goToDashboard,
          ),
        ),

        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🔷 MAIN CARD
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
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

                            /// 📄 TITLE
                            Text(
                              "Contractor Report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isWeb ? 26 : 22,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const Divider(height: 30),

                            /// 📅 FROM DATE
                            _dateField(
                              label: "From Date",
                              value: df.format(fromDate),
                              onTap: () => pickDate(true),
                            ),

                            const SizedBox(height: 14),

                            /// 📅 TILL DATE
                            _dateField(
                              label: "Till Date",
                              value: df.format(tillDate),
                              onTap: () => pickDate(false),
                            ),

                            const SizedBox(height: 16),

                            /// 👷 CONTRACTOR
                            const Text(
                              "Select Contractor",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),

                            DropdownButtonFormField<ContractorModel>(
                              value: selectedContractor,
                              items: contractors
                                  .map(
                                    (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                      "${c.conName} (${c.conCode})"),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => selectedContractor = v),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// ▶️ SHOW DATA BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF2C4D76),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (selectedContractor == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text("Please select contractor"),
                              ),
                            );
                            return;
                          }

                          await Prefs.saveContractorFilter(
                            fromDate: df.format(fromDate),
                            tillDate: df.format(tillDate),
                            conCode: selectedContractor!.conCode,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ContractorDetailsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SHOW DATA",
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
      ),
    );
  }

  /// 📦 DATE FIELD WIDGET
  Widget _dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
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
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 12),
                Text(value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
