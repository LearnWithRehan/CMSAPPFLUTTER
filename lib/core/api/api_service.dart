import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cane_day_data.dart';
import '../../models/cart_count_donga_response.dart';
import '../../models/cart_count_purchy_qty_response.dart';
import '../../models/cart_count_purchy_response.dart';
import '../../models/cart_count_response.dart';
import '../../models/centre_wise_total_cane_model.dart';
import '../../models/day_wise_centre_graph_model.dart';
import '../../models/plant_model.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/variety_day_data.dart';
import '../constants/api_constants.dart';

class ApiService {


  /* =========================
     🌱 PLANT MASTER API
     ========================= */
  static Future<List<PlantModel>> fetchPlants() async {
    final url =
    Uri.parse(ApiConstants.baseUrl + ApiConstants.plantMaster);

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      List list = jsonData['data'];
      return list.map((e) => PlantModel.fromJson(e)).toList();
    } else {
      throw Exception(jsonData['message']);
    }
  }

  /* =========================
     🔐 LOGIN API
     ========================= */
  static Future<LoginResponse> login(LoginRequest request) async {
    final url =
    Uri.parse(ApiConstants.baseUrl + ApiConstants.login);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    return LoginResponse.fromJson(
      json.decode(response.body),
    );
  }

  /* =========================
     🏭 PLANT NAME BY CODE API
     ========================= */
  static Future<String> fetchPlantNameByCode(String plantCode) async {
    final url =
    Uri.parse(ApiConstants.baseUrl + ApiConstants.plantName);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return jsonData['plantName'].toString();
    } else {
      throw Exception(jsonData['message']);
    }
  }


  //daily wise cane graph

  static Future<List<CaneDayData>> fetchCaneTrend(String plantCode) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}dayWiseCaneTrend.php"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"plantCode": plantCode},
    );

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['data'] as List)
          .map((e) => CaneDayData.fromJson(e))
          .toList();
    } else {
      throw Exception(jsonData['message']);
    }
  }

  static Future<double> fetchGrandTotal(String plantCode) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}HourlyReportTotPurGraphp.php"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"plantCode": plantCode},
    );

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['grand_total'] as num).toDouble();
    } else {
      throw Exception(jsonData['message']);
    }
  }



  // 📊 Centre wise day graph
  static Future<List<DayWiseCentreGraphModel>>
  fetchDayWiseCentreGraph(String plantCode) async {

    final response = await http.post(
      Uri.parse(
          "${ApiConstants.baseUrl}DailyCentreWiseCaneArrival.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
      },
    );

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['data'] as List)
          .map((e) =>
          DayWiseCentreGraphModel.fromJson(e))
          .toList();
    } else {
      throw Exception(jsonData['message']);
    }
  }


  /* =========================
   📊 CENTRE WISE TOTAL CANE
   ========================= */
  static Future<List<CentreWiseTotalCaneModel>>
  fetchCentreWiseTotalCane(String plantCode) async {

    final url = Uri.parse(
      ApiConstants.baseUrl + "centre_wise_total_cane_graph.php",
    );

    final response = await http.post(
      url,
      body: {"plantCode": plantCode},
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      List list = jsonData['data'];
      return list
          .map((e) => CentreWiseTotalCaneModel.fromJson(e))
          .toList();
    } else {
      throw Exception(jsonData['message']);
    }
  }



  static Future<List<VarietyDayData>> fetchDailyVarietyWise(
      String plantCode) async {

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "daily_variety_wise_cane_Graph.php"),
      body: {
        "plantCode": plantCode,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      List list = jsonData['data'];
      return list.map((e) => VarietyDayData.fromJson(e)).toList();
    } else {
      throw Exception(jsonData['message']);
    }
  }


  // ✅ CountCart API (exact Java equivalent)
  static Future<CartCountResponse> getCartCount() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final url = Uri.parse(
      ApiConstants.baseUrl + "CountInYardCart.php",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    final jsonData = json.decode(response.body);
    return CartCountResponse.fromJson(jsonData);
  }



  /// ================= CART IN DONGA =================
  static Future<CartCountDongaResponse> getCartCountDonga() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInDongaCart.php"),
      body: {
        "plantCode": plantCode ?? "",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return CartCountDongaResponse.fromJson(jsonData);
  }


  /// ================= CART PURCHASE NO =================
  static Future<CartCountPurchyResponse> getCartPurchyNo(
      String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInCartPurchy.php"),
      body: {
        "plantCode": plantCode ?? "",
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return CartCountPurchyResponse.fromJson(jsonData);
  }


  /// ================= CART PURCHASE QTY =================
  static Future<CartCountInYardResponsePurchyNoQty>
  getCartPurchyQty(String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInCartPurchyQty.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode ?? "",
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return CartCountInYardResponsePurchyNoQty.fromJson(jsonData);
  }



}
