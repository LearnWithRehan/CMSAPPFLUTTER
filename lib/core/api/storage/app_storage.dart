import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<void> saveLogin({
    required String userId,
    required int role,
    required String plantCode,
    required List<String> permissions,
  }) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString("USER_ID", userId);
    await sp.setInt("USER_ROLE", role);
    await sp.setString("PLANT_CODE", plantCode);
    await sp.setStringList("PERMISSIONS", permissions);
  }
  // ✅ ADD THIS
  static Future<String> getPlantCode() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString("PLANT_CODE") ?? "";
  }
}
