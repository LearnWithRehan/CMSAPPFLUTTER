import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/cart_count_response.dart';

class YardPositionScreen extends StatefulWidget {
  const YardPositionScreen({super.key});

  @override
  State<YardPositionScreen> createState() => _YardPositionScreenState();
}

class _YardPositionScreenState extends State<YardPositionScreen> {
  String selectedDate = "";
  String plantName = "";

  /// ================= AT GATE VALUES =================
  int cartInYard = 0;
  int cartInDonga = 0;
  int cartPurNo = 0;
  double cartPurQty = 0.0;

  int trolleyInYard = 0;
  int trolleyInDonga = 0;
  int trolleyPurNo = 0;
  double trolleyTodayQty = 0.0;

  int truckInYard = 0;
  int truckInDonga = 0;
  int truckPurNo = 0;
  double truckTodayQty = 0.0;

  double grandTotalPurchase = 0.0;


  /// ================= CENTRE RECEIPT VALUES =================
  int cnttruckInYard = 0;
  int cnttruckInDonga = 0;
  int cnttruckPurNo = 0;
  double cnttruckTodayQty = 0.0;

  /// ================= TOTALS =================
  int totalInYard = 0;
  int totalInDonga = 0;
  int totalPurNo = 0;
  double totalTodayQty = 0.0;

  double grandTotal = 0;
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    isLoading = true;
    _initAll();
  }

  Future<void> _initAll() async {
    await _loadSelectedDate(); // load selected date
    await loadData(); // load plant name

    // load all API data
    await loadCartCount();
    await loadCartCountDonga();
    await loadCartPurchyNo();
    await loadCartPurchyQty();
    await loadTrolleyCount();
    await loadTrolleyCountDonga();
    await loadTrolleyPurchyNo();
    await loadTrolleyPurchyQty();
    await loadTruckCount();
    await loadTruckCountDonga();
    await loadTruckPurchyNo();
    await loadTruckPurchyQty();
    await loadCntTruckCount();
    await loadTruckCountGross();
    await loadCntTruckPurchyNo();
    await loadCntTruckPurchyQty();
    await loadGrandTotalPurchase();


    _calculateTotals();

    // ✅ STOP LOADING
    setState(() {
      isLoading = false;
    });
  }

  /// ================= CALCULATE TOTALS =================
  void _calculateTotals() {
    totalInYard = cartInYard + trolleyInYard + truckInYard + cnttruckInYard;
    totalInDonga = cartInDonga + trolleyInDonga + truckInDonga + cnttruckInDonga;
    totalPurNo = cartPurNo + trolleyPurNo + truckPurNo + cnttruckPurNo;
    totalTodayQty = cartPurQty + trolleyTodayQty + truckTodayQty + cnttruckTodayQty;

    setState(() {});
  }


  Future<void> loadGrandTotalPurchase() async {
    try {
      if (selectedDate.isEmpty) return;

      final res = await ApiService.getGrandTotal(selectedDate);

      if (res.success == 1) {
        setState(() {
          grandTotalPurchase = res.grandTotal;
        });
      }
    } catch (e) {
      debugPrint("Grand Total Error: $e");
    }
  }



  /// ================= API LOADERS =================
  Future<void> loadCartCount() async {
    try {
      final res = await ApiService.getCartCount();
      if (res.success == 1) cartInYard = res.total;
    } catch (e) {
      debugPrint("Cart API Error: $e");
    }
  }

  Future<void> loadCartCountDonga() async {
    try {
      final res = await ApiService.getCartCountDonga();
      if (res.success == 1) cartInDonga = res.total;
    } catch (e) {
      debugPrint("Cart InDonga Error: $e");
    }
  }

  Future<void> loadCartPurchyNo() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getCartPurchyNo(selectedDate);
      if (res.success == 1) cartPurNo = res.total;
    } catch (e) {
      debugPrint("Cart Purchy No Error: $e");
    }
  }

  Future<void> loadCartPurchyQty() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getCartPurchyQty(selectedDate);
      if (res.success == 1) cartPurQty = res.total;
    } catch (e) {
      debugPrint("Cart Purchy Qty Error: $e");
    }
  }

  Future<void> loadTrolleyCount() async {
    try {
      final res = await ApiService.getTrolleyCount();
      if (res.success == 1) trolleyInYard = res.total;
    } catch (e) {
      debugPrint("Trolley Count Error: $e");
    }
  }

  Future<void> loadTrolleyCountDonga() async {
    try {
      final res = await ApiService.getTrolleyCountDonga();
      if (res.success == 1) trolleyInDonga = res.total;
    } catch (e) {
      debugPrint("Trolley Donga Error: $e");
    }
  }

  Future<void> loadTrolleyPurchyNo() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getTrolleyPurchyNo(selectedDate);
      if (res.success == 1) trolleyPurNo = res.total;
    } catch (e) {
      debugPrint("Trolley Purchy No Error: $e");
    }
  }

  Future<void> loadTrolleyPurchyQty() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getTrolleyPurchyQty(selectedDate);
      if (res.success == 1) trolleyTodayQty = res.total;
    } catch (e) {
      debugPrint("Trolley Purchy Qty Error: $e");
    }
  }

  Future<void> loadTruckCount() async {
    try {
      final res = await ApiService.getTruckCount();
      if (res.success == 1) truckInYard = res.total;
    } catch (e) {
      debugPrint("Truck In Yard Error: $e");
    }
  }

  Future<void> loadTruckCountDonga() async {
    try {
      final res = await ApiService.getTruckCountDonga();
      if (res.success == 1) truckInDonga = res.total;
    } catch (e) {
      debugPrint("Truck In Donga Error: $e");
    }
  }

  Future<void> loadTruckPurchyNo() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getTruckCountPurchyNo(selectedDate);
      if (res.success == 1) truckPurNo = res.total;
    } catch (e) {
      debugPrint("Truck Purchy No Error: $e");
    }
  }

  Future<void> loadTruckPurchyQty() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getTruckCountPurchyNoQty(selectedDate);
      if (res.success == 1) truckTodayQty = res.total;
    } catch (e) {
      debugPrint("Truck Purchy Qty Error: $e");
    }
  }

  Future<void> loadCntTruckCount() async {
    try {
      final res = await ApiService.getCntTruckCount();
      if (res.success == 1) cnttruckInYard = res.total;
    } catch (e) {
      debugPrint("Cnt Truck Count Error: $e");
    }
  }

  Future<void> loadTruckCountGross() async {
    try {
      final res = await ApiService.getTruckCountGross();
      if (res.success == 1) cnttruckInDonga = res.total;
    } catch (e) {
      debugPrint("Truck Gross Count Error: $e");
    }
  }

  Future<void> loadCntTruckPurchyNo() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getCntTruckCountPurchyNo(selectedDate);
      if (res.success == 1) cnttruckPurNo = res.total;
    } catch (e) {
      debugPrint("Truck Purchy No Error: $e");
    }
  }

  Future<void> loadCntTruckPurchyQty() async {
    try {
      if (selectedDate.isEmpty) return;
      final res = await ApiService.getCntTruckCountPurchyNoQty(selectedDate);
      if (res.success == 1) cnttruckTodayQty = res.total;
    } catch (e) {
      debugPrint("Truck Purchy Qty Error: $e");
    }
  }

  /// ================= LOAD PREF + PLANT =================
  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");
    if (plantCode != null) plantName = await ApiService.fetchPlantNameByCode(plantCode);
    setState(() {});
  }

  /// ================= LOAD DATE =================
  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDate = prefs.getString("SELECTED_DATE") ?? "";
    setState(() {});
  }

  /// ================= UI HELPERS =================
  Widget cell(String text, {bool bold = false}) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget row(List<String> values, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: values.map((e) => cell(e, bold: bold)).toList()),
    );
  }

  Widget titleLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yard Position"), centerTitle: true),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // 🔄 ANDROID JAISE
      )
      : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PLANT NAME
            Center(
              child: Text(
                plantName.isEmpty ? "Cane Management System" : plantName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            /// DATE
            Row(
              children: [
                const Expanded(child: Text("Yard Position as on Date:")),
                Text(selectedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),

            /// HEADER
            row(["Supply", "InYard", "InDonga", "Pur No", "TodayPur(Qty)"], bold: true),

            /// ================= AT GATE =================
            titleLine("----------- AT GATE -----------"),
            row(["Cart", "$cartInYard", "$cartInDonga", "$cartPurNo", "${cartPurQty.toStringAsFixed(2)}"]),
            row(["Trolley", "$trolleyInYard", "$trolleyInDonga", "$trolleyPurNo", "${trolleyTodayQty.toStringAsFixed(2)}"]),
            row(["Truck", "$truckInYard", "$truckInDonga", "$truckPurNo", "${truckTodayQty.toStringAsFixed(2)}"]),

            /// ================= CENTRE =================
            titleLine("------- CENTRE RECEIPT -------"),
            row(["Truck", "$cnttruckInYard", "$cnttruckInDonga", "$cnttruckPurNo", "${cnttruckTodayQty.toStringAsFixed(2)}"]),

            titleLine("==================================="),
            row([
              "Total",
              "$totalInYard",
              "$totalInDonga",
              "$totalPurNo",
              "${totalTodayQty.toStringAsFixed(2)}"
            ], bold: true),
            titleLine("==================================="),

            const SizedBox(height: 10),
            Text(
              "Todate Purchase : ${grandTotalPurchase.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
