import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/RoleItem.dart';
import '../models/ScreenMasterModel.dart';
import '../models/ScreenPermissionModel.dart';
import '../models/SavePermissionRequest.dart';

class ScreenMasterScreen extends StatefulWidget {
  const ScreenMasterScreen({super.key});

  @override
  State<ScreenMasterScreen> createState() => _ScreenMasterScreenState();
}

class _ScreenMasterScreenState extends State<ScreenMasterScreen> {
  String plantCode = "";
  RoleItem? selectedRole;

  List<RoleItem> roleList = [];
  List<ScreenMasterModel> screenList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  /// 🔹 Load plant code & roles
  Future<void> _initData() async {
    final sp = await SharedPreferences.getInstance();
    plantCode = sp.getString("PLANT_CODE") ?? "";

    roleList = await ApiService.getUserRoles(plantCode);

    setState(() {});
  }

  /// 🔹 Load screens + permissions
  Future<void> _loadScreens(String roleId) async {
    setState(() {
      isLoading = true;
      screenList.clear();
    });

    try {
      final screens = await ApiService.getScreenMaster(plantCode);
      final allowedScreens =
      await ApiService.getRoleScreenPermission(plantCode, roleId);

      for (var s in screens) {
        final id = int.tryParse(s.screenId);
        s.isChecked = id != null && allowedScreens.contains(id);
      }

      setState(() {
        screenList = screens;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading screens: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔹 Save permission
  Future<void> _savePermission() async {
    if (selectedRole == null) return;

    final selectedScreens = screenList
        .where((e) => e.isChecked)
        .map((e) => ScreenPermissionModel(e.screenId, e.screenName))
        .toList();

    if (selectedScreens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one screen")),
      );
      return;
    }

    try {
      final msg = await ApiService.savePermission(
        SavePermissionRequest(
          plantCode,
          selectedRole!.roleId.toString(),
          selectedScreens,
        ),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving permissions: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Screen Master"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔽 ROLE DROPDOWN
                  DropdownButtonFormField<RoleItem>(
                    decoration: const InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRole,
                    items: roleList
                        .map((role) => DropdownMenuItem<RoleItem>(
                      value: role,
                      child: Text(role.roleName),
                    ))
                        .toList(),
                    onChanged: (role) {
                      setState(() {
                        selectedRole = role;
                      });

                      if (role != null) {
                        _loadScreens(role.roleId.toString());
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  /// 📋 SCREEN LIST
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : screenList.isEmpty
                        ? const Center(
                      child: Text(
                        "No screens found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: screenList.length,
                      itemBuilder: (_, i) {
                        final item = screenList[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: CheckboxListTile(
                            title: Text(
                              "${item.screenName} (${item.screenId})",
                            ),
                            value: item.isChecked,
                            activeColor: Colors.indigo,
                            onChanged: (v) {
                              setState(() {
                                item.isChecked = v ?? false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 💾 SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                      selectedRole == null ? null : _savePermission,
                      child: const Text(
                        "Save Permissions",
                        style: TextStyle(
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
    );
  }
}
