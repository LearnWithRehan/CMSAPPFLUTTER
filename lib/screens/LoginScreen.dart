import 'package:canemanagementsystem/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';
import '../../models/plant_model.dart';
import '../core/api/storage/app_storage.dart';
import '../models/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<PlantModel> plantList = [];
  PlantModel? selectedPlant;
  bool loading = true;

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFF3E5F5),
            ],
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 420 : double.infinity,
              ),
              child: Card(
                elevation: isWeb ? 10 : 0,
                margin: EdgeInsets.symmetric(
                  horizontal: isWeb ? 0 : 16,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      /// 🔰 Logo
                      Image.asset(
                        "assets/images/loginn.png",
                        width: 140,
                        height: 140,
                      ),

                      const SizedBox(height: 16),

                      /// 🏷️ Title
                      const Text(
                        "Cane Management System",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 26),

                      /// 🌱 Plant Dropdown
                      Container(
                        height: 55,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
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
                            icon:
                            const Icon(Icons.arrow_drop_down),
                            items: plantList.map((plant) {
                              return DropdownMenuItem<PlantModel>(
                                value: plant,
                                child: Text(
                                  plant.plantCode == "0"
                                      ? plant.plantName
                                      : "${plant.plantName} (${plant.plantCode})",
                                  overflow:
                                  TextOverflow.ellipsis,
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

                      const SizedBox(height: 16),

                      /// 👤 Username
                      TextField(
                        controller: usernameCtrl,
                        decoration: InputDecoration(
                          hintText: "Username",
                          prefixIcon:
                          const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔐 Password
                      TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon:
                          const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// 🔘 Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 14),
                            backgroundColor:
                            const Color(0xFF6A1B9A),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (usernameCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Enter User ID")),
                              );
                              return;
                            }

                            if (passwordCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Enter Password")),
                              );
                              return;
                            }

                            if (selectedPlant == null ||
                                selectedPlant!.plantCode ==
                                    "0") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select plant")),
                              );
                              return;
                            }

                            try {
                              final response =
                              await ApiService.login(
                                LoginRequest(
                                  userId: usernameCtrl.text
                                      .trim(),
                                  password:
                                  passwordCtrl.text
                                      .trim(),
                                  plantCode: selectedPlant!
                                      .plantCode,
                                ),
                              );

                              if (response.success == 1) {
                                await Prefs.saveLogin(
                                  userId:
                                  response.user!.userId,
                                  role:
                                  response.user!.userRole,
                                  plantCode:
                                  selectedPlant!.plantCode,
                                  permissions:
                                  response.permissions,
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const DashboardScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          response.message)),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                    content:
                                    Text(e.toString())),
                              );
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
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
      ),
    );
  }
}
