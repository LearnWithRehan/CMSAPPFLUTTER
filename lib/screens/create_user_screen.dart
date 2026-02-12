import 'package:flutter/material.dart';
import 'package:CMS/core/api/api_service.dart';
import 'package:CMS/core/api/storage/app_storage.dart';
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

  Future<void> _init() async {
    _plantCode = await Prefs.getPlantCode();
    if (_plantCode.isEmpty) {
      _showMsg("Plant code missing");
      return;
    }
    await _loadRoles();
    await _loadUsers();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await ApiService.getUserRoles(_plantCode);
      if (!mounted) return;

      setState(() {
        _roles = [RoleItem(roleId: 0, roleName: "Select Role"), ...roles];
        _selectedRole = _roles.first;
      });
    } catch (e) {
      _showMsg("Role Error: $e");
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await ApiService.getUsers(_plantCode);
      if (!mounted) return;
      setState(() => _users = users);
    } catch (e) {
      _showMsg("User Error: $e");
    }
  }

  Future<void> _saveUser() async {
    if (_usernameCtrl.text.trim().isEmpty) return _showMsg("Username required");
    if (_passwordCtrl.text.trim().isEmpty) return _showMsg("Password required");
    if (_selectedRole == null || _selectedRole!.roleId == 0) return _showMsg("Please select role");

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

  Future<void> _deleteUser(String userId, int index) async {
    final adminRole = await Prefs.getUserRole();
    if (adminRole != 1) return _showMsg("Unauthorized");

    setState(() => _loading = true);
    try {
      final msg = await ApiService.deleteUser(
        plantCode: _plantCode,
        userId: userId,
        adminRole: adminRole,
      );
      if (!mounted) return;

      setState(() => _users.removeAt(index));
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
          TextButton(child: const Text("No"), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Create User"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFormCardContent(),
                        const SizedBox(height: 25),
                        _buildUserListContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormCardContent() {
    return Column(
      children: [
        TextField(
          controller: _usernameCtrl,
          decoration: InputDecoration(
            labelText: "Username",
            prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.deepPurple.shade50,
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passwordCtrl,
          obscureText: _hidePassword,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
            suffixIcon: IconButton(
              icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.deepPurple.shade50,
          ),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<RoleItem>(
          value: _selectedRole,
          decoration: InputDecoration(
            labelText: "Role",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.deepPurple.shade50,
          ),
          items: _roles
              .map((e) => DropdownMenuItem<RoleItem>(
            value: e,
            child: Text(e.roleName),
          ))
              .toList(),
          onChanged: (val) => setState(() => _selectedRole = val),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save User", style: TextStyle(fontSize: 16)),
            onPressed: _saveUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent.shade400, // bright & readable
              // New attractive button color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserListContent() {
    return _users.isEmpty
        ? Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: const Text("No users found", style: TextStyle(fontSize: 16)),
    )
        : ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: _users.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final user = _users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: const Icon(Icons.person, color: Colors.deepPurple),
          ),
          title: Text(user.userId,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(user.userId, index),
          ),
          tileColor: Colors.deepPurple.shade50.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        );
      },
    );
  }
}
