import 'dart:convert';
import 'package:canemanagementsystem/core/api/storage/app_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/CntTruckCountInDongaResponse.dart';
import '../../models/CntTruckCountInGrossResponse.dart';
import '../../models/CntTruckCountInYardResponsePurchyNo.dart';
import '../../models/CntTruckCountInYardResponsePurchyNoQty.dart';
import '../../models/RoleItem.dart';
import '../../models/TruckCountInYardResponsePurchyNo.dart';
import '../../models/TruckCountInYardResponsePurchyNoQty.dart';
import '../../models/UserItem.dart';
import '../../models/cane_day_data.dart';
import '../../models/cart_count_donga_response.dart';
import '../../models/cart_count_purchy_qty_response.dart';
import '../../models/cart_count_purchy_response.dart';
import '../../models/cart_count_response.dart';
import '../../models/centre_kudiya_purchase_model.dart';
import '../../models/centre_mill_gate_model.dart';
import '../../models/centre_purchase_model.dart';
import '../../models/centre_response.dart';
import '../../models/centre_wise_total_cane_model.dart';
import '../../models/contractor_model.dart';
import '../../models/contractor_receipt_model.dart';
import '../../models/day_wise_centre_graph_model.dart';
import '../../models/grand_total_response.dart';
import '../../models/hourly_row_model.dart';
import '../../models/plant_model.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/trolley_count_in_donga_response.dart';
import '../../models/trolley_count_in_yard_response.dart';
import '../../models/trolley_count_purchy_qty_response.dart';
import '../../models/trolley_count_purchy_response.dart';
import '../../models/truck_count_donga_response.dart';
import '../../models/truck_count_in_yard_response.dart';
import '../../models/variety_day_data.dart';
import '../../models/village_wise_model.dart';
import '../../models/wb_control_response.dart';
import '../../models/wb_status_item.dart';
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


  /// ================= TROLLEY IN YARD =================
  static Future<TrolleyCountInYardResponse> getTrolleyCount() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInYardTrolley.php"),
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
    return TrolleyCountInYardResponse.fromJson(jsonData);
  }



  /// ================= TROLLEY IN DONGA =================
  static Future<TrolleyCountInDongaResponse> getTrolleyCountDonga() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInDongaTrolley.php"),
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
    return TrolleyCountInDongaResponse.fromJson(jsonData);
  }


  /// ================= TROLLEY PURCHASE NO =================
  static Future<TrolleyCountPurchyResponse> getTrolleyPurchyNo(
      String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInTrolleyPurchy.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return TrolleyCountPurchyResponse.fromJson(jsonData);
  }



  /// ================= TROLLEY PURCHASE QTY =================
  static Future<TrolleyCountPurchyQtyResponse>
  getTrolleyPurchyQty(String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInTrolyPurchyQty.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return TrolleyCountPurchyQtyResponse.fromJson(jsonData);
  }



  /// ================= TRUCK IN YARD =================
  static Future<TruckCountInYardResponse> getTruckCount() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInYardTruck.php"),
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
    return TruckCountInYardResponse.fromJson(jsonData);
  }



  /// ================= TRUCK IN DONGA =================
  static Future<TruckCountInDongaResponse> getTruckCountDonga() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInDongaTruck.php"),
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
    return TruckCountInDongaResponse.fromJson(jsonData);
  }



  /// ================= TRUCK PURCHY NO =================
  static Future<TruckCountInYardResponsePurchyNo>
  getTruckCountPurchyNo(String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInTruckPurchy.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return TruckCountInYardResponsePurchyNo.fromJson(jsonData);
  }


  /// ================= TRUCK PURCHY QTY =================
  static Future<TruckCountInYardResponsePurchyNoQty>
  getTruckCountPurchyNoQty(String selectedDate) async {

    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInTruckPurchyQty.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return TruckCountInYardResponsePurchyNoQty.fromJson(jsonData);
  }


  /// ================= TRUCK COUNT IN YARD =================
  static Future<CntTruckCountInDongaResponse> getCntTruckCount() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInYardCnt.php"),
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
    return CntTruckCountInDongaResponse.fromJson(jsonData);
  }


  /// ================= TRUCK GROSS COUNT =================
  static Future<CntTruckCountInGrossResponse> getTruckCountGross() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInGrossCnt.php"),
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
    return CntTruckCountInGrossResponse.fromJson(jsonData);
  }


  /// ================= TRUCK PURCHASE NO (DATE WISE) =================
  static Future<CntTruckCountInYardResponsePurchyNo> getCntTruckCountPurchyNo(String selectedDate) async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInCntTruckPurchy.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error: ${response.statusCode}");
    }

    final jsonData = json.decode(response.body);
    return CntTruckCountInYardResponsePurchyNo.fromJson(jsonData);
  }



  /// ================= TRUCK PURCHASE QTY (DATE WISE) =================
  static Future<CntTruckCountInYardResponsePurchyNoQty> getCntTruckCountPurchyNoQty(String selectedDate) async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "CountInCntTruckPurchyQty.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error: ${response.statusCode}");
    }

    final jsonData = json.decode(response.body);
    return CntTruckCountInYardResponsePurchyNoQty.fromJson(jsonData);
  }


  /// =========================
  /// 📊 GRAND TOTAL TODATE PURCHASE
  /// =========================
  static Future<GrandTotalResponse> getGrandTotal(String selectedDate) async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.hourlyReportTotPur),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return GrandTotalResponse.fromJson(jsonData);
  }



// =========================
// ⏱ HOURLY CRUSHING (SHIFT A / B / C)
// =========================
  static Future<List<HourlyRowModel>> fetchHourlyShift(
      String endpoint,
      String plantCode,
      String selectedDate,
      ) async {

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['data'] as List)
          .map((e) => HourlyRowModel.fromJson(e))
          .toList();
    } else {
      throw Exception(jsonData['message'] ?? "API Error");
    }
  }



  static Future<CentreResponse> getCentreReport(String date) async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null || plantCode.isEmpty) {
      throw Exception("Plant code not found in preferences");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "centreWiseReport.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "date": date,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    final jsonData = json.decode(response.body);
    return CentreResponse.fromJson(jsonData);
  }



  static Future<double> fetchVarietyTotal(
      String endpoint,
      String selectedDate,
      ) async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode == null) {
      throw Exception("Plant code not found");
    }

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "selectedDate": selectedDate, // dd-MM-yyyy
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['total'] ?? 0).toDouble();
    } else {
      throw Exception(jsonData['message']);
    }
  }



  static Future<List<CentrePurchaseModel>> fetchCentreWisePurchase(
      String plantCode,
      String date,
      ) async {

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "centreWiseReportBha.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "plantCode": plantCode,
        "date": date,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final data = jsonDecode(response.body);

    if (data['success'] != 1) {
      throw Exception(data['message'] ?? "No Data");
    }

    final List list = data['centres'];
    return list.map((e) => CentrePurchaseModel.fromJson(e)).toList();
  }




  static Future<List<CentreKudiyaPurchaseModel>>
  fetchCentreWiseKudiyaPurchase(
      String plantCode,
      String date,
      ) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "centreWiseReportKudiyaPurchase.php"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "plantCode": plantCode,
        "date": date,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final data = jsonDecode(response.body);

    if (data['success'] != 1) {
      throw Exception(data['message'] ?? "No Data");
    }

    final List list = data['centres'];
    return list
        .map((e) => CentreKudiyaPurchaseModel.fromJson(e))
        .toList();
  }




  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, String> body) async {

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Server Error");
    }
  }


  // 🔹 Contractor List
  static Future<List<ContractorModel>> getContractorList() async {
    final plantCode = await Prefs.getPlantCode();

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "get_contractor_list.php"),
      body: {"plantCode": plantCode},
    );

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      List list = jsonData['data'];
      return list.map((e) => ContractorModel.fromJson(e)).toList();
    } else {
      throw Exception("Contractor not found");
    }
  }

  static Future<List<ContractorReceiptModel>> getContractorReceipt({
    required String fromDate,
    required String tillDate,
    required String conCode,
  }) async {
    final plantCode = await Prefs.getPlantCode();

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + "get_contractor_receipt.php"),
      body: {
        "plantCode": plantCode,
        "conCode": conCode,
        "fromDate": fromDate,
        "tillDate": tillDate,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (jsonData['success'] == 1) {
      return (jsonData['data'] as List)
          .map((e) => ContractorReceiptModel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }


  static Future<List<CentreMillGateModel>> fetchCentreMillGate({
    required String plantCode,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}CntMillGateReport.php"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "plantCode": plantCode,
        "date": date,
      },
    );

    final jsonData = json.decode(response.body);

    if (jsonData["success"] == 1) {
      return (jsonData["data"] as List)
          .map((e) => CentreMillGateModel.fromJson(e))
          .toList();
    } else {
      throw Exception(jsonData["message"]);
    }
  }


  static Future<List<VillageWiseItem>> fetchVillageWise(
      String plantCode,
      String date,
      ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}VillageWisePurchase.php"),
      body: {
        "plantCode": plantCode,
        "date": date,
      },
    );

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1) {
      final List list = jsonData['data'];
      return list.map((e) => VillageWiseItem.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<UserItem>> getUsers(String plantCode) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getUsers),
      body: {
        "plantCode": plantCode,
      },
    );

    debugPrint("GET USERS RESPONSE => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1 && jsonData['users'] != null) {
      return (jsonData['users'] as List)
          .map((e) => UserItem.fromJson(e))
          .toList();
    }
    return [];
  }


  static Future<List<RoleItem>> getUserRoles(String plantCode) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getUserRoles),
      body: {
        "plantCode": plantCode,
      },
    );

    debugPrint("GET ROLES RESPONSE => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);

    if (jsonData['success'] == 1 && jsonData['roles'] != null) {
      return (jsonData['roles'] as List)
          .map((e) => RoleItem.fromJson(e))
          .toList();
    }
    return [];
  }


  static Future<String> createUser({
    required String username,
    required String password,
    required int roleId,
    required String plantCode,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.createUser),
      body: {
        "username": username,
        "password": password,
        "role_id": roleId.toString(),
        "plantCode": plantCode,
      },
    );

    debugPrint("CREATE USER RESPONSE => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return jsonData['message'] ?? "Something went wrong";
  }


  static Future<String> deleteUser({
    required String plantCode,
    required String userId,
    required int adminRole,
  }) async {
    final res = await post(
      ApiConstants.deleteUser,
      {
        "plantCode": plantCode,
        "userId": userId,
        "adminRole": adminRole.toString(),
      },
    );

    if (res['success'] == 1) {
      return res['message']?.toString() ?? "User deleted successfully";
    } else {
      throw Exception(res['message']?.toString() ?? "Delete failed");
    }
  }






  static Future<List<String>> getWbNoList(String plantCode) async {
    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}get_wb_no.php"),
      body: {"plantCode": plantCode},
    );

    final data = jsonDecode(res.body);
    if (data['success'] == 1) {
      return List<String>.from(data['data']);
    }
    return [];
  }

  static Future<List<WbStatusItem>> getWbStatusList(String plantCode) async {
    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}wb_control.php"),
      body: {"plantCode": plantCode},
    );

    final data = jsonDecode(res.body);
    if (data['success'] == 1) {
      return (data['data'] as List)
          .map((e) => WbStatusItem.fromJson(e))
          .toList();
    }
    return [];
  }
  static Future<WbControlData?> getWbControlDetails(
      String plantCode, String wbNo) async {

    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}get_wb_control_details.php"),
      body: {
        "plantCode": plantCode,
        "wbNo": wbNo,
      },
    );

    final data = jsonDecode(res.body);
    if (data['success'] == 1) {
      return WbControlData.fromJson(data['data']);
    }
    return null;
  }
  static Future<String> updateWbFlag(
      String plantCode, String wbNo, String flag) async {

    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}update_wb_flag.php"),
      body: {
        "plantCode": plantCode,
        "wbNo": wbNo,
        "wFlag": flag,
      },
    );

    final data = jsonDecode(res.body);
    return data['message'] ?? "Updated";
  }





}
