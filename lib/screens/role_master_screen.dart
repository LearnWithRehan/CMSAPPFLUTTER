import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/role_model.dart';

class RoleMasterScreen extends StatefulWidget {
  const RoleMasterScreen({Key? key}) : super(key: key);

  @override
  State<RoleMasterScreen> createState() => _RoleMasterScreenState();
}

class _RoleMasterScreenState extends State<RoleMasterScreen> {
  final roleIdCtrl = TextEditingController();
  final roleNameCtrl = TextEditingController();

  List<RoleModel> roleList = [];
  bool loading = false;
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    plantCode = await Prefs.getPlantCode();
    if (plantCode.isEmpty) {
      _msg("Plant Code missing");
      return;
    }
    await _loadNextRoleId();
    await _loadRoles();
  }

  Future<void> _loadNextRoleId() async {
    try {
      roleIdCtrl.text =
          (await ApiService.getNextRoleId(plantCode)).toString();
    } catch (e) {
      _msg(e.toString());
    }
  }

  Future<void> _loadRoles() async {
    setState(() => loading = true);
    try {
      roleList = await ApiService.getAllRoles(plantCode);
    } catch (e) {
      _msg(e.toString());
    }
    setState(() => loading = false);
  }

  Future<void> _saveRole() async {
    if (roleNameCtrl.text.trim().isEmpty) {
      _msg("Enter Role Name");
      return;
    }

    setState(() => loading = true);
    try {
      final msg = await ApiService.saveRoleMaster(
        plantCode,
        roleIdCtrl.text,
        roleNameCtrl.text.trim(),
      );
      _msg(msg);
      roleNameCtrl.clear();
      await _loadNextRoleId();
      await _loadRoles();
    } catch (e) {
      _msg(e.toString());
    }
    setState(() => loading = false);
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("ROLE MASTER"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520, // ⭐ responsive on tablet/web
                ),
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.indigo.withOpacity(.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Create New Role",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 22),

                        /// ROLE ID
                        TextField(
                          controller: roleIdCtrl,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Role ID",
                            prefixIcon: const Icon(Icons.tag),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        /// ROLE NAME
                        TextField(
                          controller: roleNameCtrl,
                          decoration: InputDecoration(
                            labelText: "Role Name",
                            prefixIcon: const Icon(Icons.security),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        /// SAVE BUTTON
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _saveRole,
                            icon: const Icon(Icons.save),
                            label: const Text(
                              "SAVE ROLE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 14),

                        const Text(
                          "Existing Roles",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),

                        /// ROLE LIST
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: roleList.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                          itemBuilder: (_, i) {
                            final r = roleList[i];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                  Colors.indigo.shade100,
                                  child: Text(
                                    r.roleId,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  r.roleName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// LOADER
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
