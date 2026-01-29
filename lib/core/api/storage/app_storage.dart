import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  /* =====================
     🔐 LOGIN DATA
     ===================== */
  static Future<void> saveLogin({
    required String userId,
    required int role,
    required String plantCode,
    required List<String> permissions,
  }) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString("USER_ID", userId);
    await sp.setInt("USER_ROLE", role); // Save role properly
    await sp.setString("PLANT_CODE", plantCode);
    await sp.setStringList("PERMISSIONS", permissions);
  }

  static Future<int> getUserRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt("USER_ROLE") ?? 0; // default to 0 if not set
  }

  static Future<String> getPlantCode() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString("PLANT_CODE") ?? "";
  }

  /* =====================
     📅 CONTRACTOR FILTER
     ===================== */
  static Future<void> saveContractorFilter({
    required String fromDate,
    required String tillDate,
    required String conCode,
  }) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString("FROM_DATECON", fromDate);
    await sp.setString("TILL_DATECON", tillDate);
    await sp.setString("CON_CODE", conCode);
  }

  static Future<Map<String, String>> getContractorFilter() async {
    final sp = await SharedPreferences.getInstance();

    return {
      "fromDate": sp.getString("FROM_DATECON") ?? "",
      "tillDate": sp.getString("TILL_DATECON") ?? "",
      "conCode": sp.getString("CON_CODE") ?? "",
    };
  }

  /* =====================
     🧹 CLEAR (OPTIONAL)
     ===================== */
  static Future<void> clearContractorFilter() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove("FROM_DATECON");
    await sp.remove("TILL_DATECON");
    await sp.remove("CON_CODE");
  }

  /* =====================
     🔓 LOGOUT (OPTIONAL)
     ===================== */
  static Future<void> clearLogin() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove("USER_ID");
    await sp.remove("USER_ROLE");
    await sp.remove("PLANT_CODE");
    await sp.remove("PERMISSIONS");
  }
}
