import 'package:flutter/material.dart';
import 'package:canemanagementsystem/core/api/api_service.dart';
import 'package:canemanagementsystem/core/api/storage/app_storage.dart';
import '../../models/RoleItem.dart';
import '../../models/UserItem.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  List<RoleItem> _roles = [];
  RoleItem? _selectedRole;

  List<UserItem> _users = [];

  String _plantCode = "";
  bool _loading = false;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// ================= INIT =================
  Future<void> _init() async {
    _plantCode = await Prefs.getPlantCode();

    if (_plantCode.isEmpty) {
      _showMsg("Plant code missing");
      return;
    }

    await _loadRoles();
    await _loadUsers();
  }

  /// ================= LOAD ROLES =================
  Future<void> _loadRoles() async {
    try {
      final roles = await ApiService.getUserRoles(_plantCode);
      if (!mounted) return;

      setState(() {
        _roles = [
          RoleItem(roleId: 0, roleName: "Select Role"),
          ...roles,
        ];
        _selectedRole = _roles.first;
      });
    } catch (e) {
      _showMsg("Role Error: $e");
    }
  }

  /// ================= LOAD USERS =================
  Future<void> _loadUsers() async {
    try {
      final users = await ApiService.getUsers(_plantCode);
      if (!mounted) return;

      setState(() => _users = users);
    } catch (e) {
      _showMsg("User Error: $e");
    }
  }

  /// ================= SAVE USER =================
  Future<void> _saveUser() async {
    if (_usernameCtrl.text.trim().isEmpty) {
      _showMsg("Username required");
      return;
    }

    if (_passwordCtrl.text.trim().isEmpty) {
      _showMsg("Password required");
      return;
    }

    if (_selectedRole == null || _selectedRole!.roleId == 0) {
      _showMsg("Please select role");
      return;
    }

    setState(() => _loading = true);

    try {
      final msg = await ApiService.createUser(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        roleId: _selectedRole!.roleId,
        plantCode: _plantCode,
      );

      _showMsg(msg);

      _usernameCtrl.clear();
      _passwordCtrl.clear();
      _selectedRole = _roles.first;

      await _loadUsers();
    } catch (e) {
      _showMsg("Save Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// ================= DELETE USER =================
  Future<void> _deleteUser(String userId, int index) async {
    final adminRole = await Prefs.getUserRole();

    if (adminRole != 1) {
      _showMsg("Unauthorized");
      return;
    }

    setState(() => _loading = true);

    try {
      final msg = await ApiService.deleteUser(
        plantCode: _plantCode,
        userId: userId,
        adminRole: adminRole,
      );

      if (!mounted) return;

      setState(() {
        _users.removeAt(index);
      });

      _showMsg(msg);
    } catch (e) {
      _showMsg("Delete Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  void _confirmDelete(String userId, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(userId, index);
            },
          ),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFormCard(),
                const SizedBox(height: 16),
                _buildUserList(),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// ================= FORM CARD =================
  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passwordCtrl,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<RoleItem>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(),
              ),
              items: _roles
                  .map(
                    (e) => DropdownMenuItem<RoleItem>(
                  value: e,
                  child: Text(e.roleName),
                ),
              )
                  .toList(),
              onChanged: (val) =>
                  setState(() => _selectedRole = val),
            ),
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save User"),
                onPressed: _saveUser,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= USER LIST =================
  Widget _buildUserList() {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _users.isEmpty
            ? const Center(child: Text("No users found"))
            : ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: _users.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final user = _users[index];
            return ListTile(
              leading:
              const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.userId),
              trailing: TextButton(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () =>
                    _confirmDelete(user.userId, index),
              ),
            );
          },
        ),
      ),
    );
  }
}
