import 'package:flutter/material.dart';
import 'grower_calendar_details_design.dart';
import '../../core/api/api_service.dart';
import '../../models/plant_model.dart';

class GrowerCalendarScreen extends StatefulWidget {
  const GrowerCalendarScreen({super.key});

  @override
  State<GrowerCalendarScreen> createState() =>
      _GrowerCalendarScreenState();
}

class _GrowerCalendarScreenState
    extends State<GrowerCalendarScreen> {

  final TextEditingController villageController =
  TextEditingController();
  final TextEditingController growerController =
  TextEditingController();

  List<PlantModel> plantList = [];
  PlantModel? selectedPlant;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  Future<void> loadPlants() async {
    try {
      plantList = await ApiService.fetchPlants();
      plantList.insert(
        0,
        PlantModel(plantCode: "0", plantName: "Select Plant"),
      );

      setState(() {
        selectedPlant = plantList.first;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// ▶️ SHOW BUTTON CLICK
  void _onShow() {
    final village = villageController.text.trim();
    final grower = growerController.text.trim();

    if (selectedPlant == null || selectedPlant!.plantCode == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select plant")),
      );
      return;
    }

    if (village.isEmpty || grower.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Village aur Grower code enter karo"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GrowerCalendarDetailsDesign(
          plantCode: selectedPlant!.plantCode,
          village: village,
          grower: grower,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          "Grower Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 520 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [

                    const Text(
                      "Grower Calendar Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 🌱 Plant Dropdown
                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PlantModel>(
                          value: selectedPlant,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: plantList.map((plant) {
                            return DropdownMenuItem<PlantModel>(
                              value: plant,
                              child: Text(
                                plant.plantCode == "0"
                                    ? plant.plantName
                                    : "${plant.plantName} (${plant.plantCode})",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPlant = value;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _inputField(
                      label: "Village Code",
                      controller: villageController,
                      icon: Icons.location_on_outlined,
                    ),

                    const SizedBox(height: 18),

                    _inputField(
                      label: "Grower Code",
                      controller: growerController,
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _onShow,
                        icon: const Icon(Icons.search),
                        label: const Text(
                          "SHOW DETAILS",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF7FA481),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
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

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
