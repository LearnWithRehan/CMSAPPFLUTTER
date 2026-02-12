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

  bool isLoading = true;

  final Color primaryColor = const Color(0xFF1B5E20);
  final Color bgColor = const Color(0xFFF1F8E9);

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _loadSelectedDate();
    await loadData();

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

    setState(() => isLoading = false);
  }

  void _calculateTotals() {
    totalInYard = cartInYard + trolleyInYard + truckInYard + cnttruckInYard;
    totalInDonga = cartInDonga + trolleyInDonga + truckInDonga + cnttruckInDonga;
    totalPurNo = cartPurNo + trolleyPurNo + truckPurNo + cnttruckPurNo;
    totalTodayQty =
        cartPurQty + trolleyTodayQty + truckTodayQty + cnttruckTodayQty;
  }

  /// ================= API METHODS =================

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

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");
    if (plantCode != null) {
      plantName = await ApiService.fetchPlantNameByCode(plantCode);
    }
    setState(() {});
  }

  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDate = prefs.getString("SELECTED_DATE") ?? "";
    setState(() {});
  }

  /// ================= UI =================

  Widget buildRow(List<String> values,
      {bool isHeader = false, bool isTotal = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: isHeader
            ? primaryColor.withOpacity(0.1)
            : isTotal
            ? Colors.orange.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: values
            .map(
              (e) => Expanded(
            child: Text(
              e,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight:
                isHeader || isTotal ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                color: isHeader ? primaryColor : Colors.black87,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor),
        ),
      ),
    );
  }

  Widget cardWrapper(Widget child) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Yard Position"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            cardWrapper(
              Column(
                children: [
                  Text(
                    plantName.isEmpty
                        ? "Cane Management System"
                        : plantName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Yard Position as on $selectedDate",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            cardWrapper(
              Column(
                children: [
                  buildRow(
                      ["Supply", "InYard", "InDonga", "Pur No", "Qty"],
                      isHeader: true),
                  sectionTitle("AT GATE"),
                  buildRow([
                    "Cart",
                    "$cartInYard",
                    "$cartInDonga",
                    "$cartPurNo",
                    cartPurQty.toStringAsFixed(2)
                  ]),
                  buildRow([
                    "Trolley",
                    "$trolleyInYard",
                    "$trolleyInDonga",
                    "$trolleyPurNo",
                    trolleyTodayQty.toStringAsFixed(2)
                  ]),
                  buildRow([
                    "Truck",
                    "$truckInYard",
                    "$truckInDonga",
                    "$truckPurNo",
                    truckTodayQty.toStringAsFixed(2)
                  ]),
                  sectionTitle("CENTRE RECEIPT"),
                  buildRow([
                    "Truck",
                    "$cnttruckInYard",
                    "$cnttruckInDonga",
                    "$cnttruckPurNo",
                    cnttruckTodayQty.toStringAsFixed(2)
                  ]),
                  const SizedBox(height: 10),
                  buildRow([
                    "TOTAL",
                    "$totalInYard",
                    "$totalInDonga",
                    "$totalPurNo",
                    totalTodayQty.toStringAsFixed(2)
                  ], isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "TODATE PURCHASE",
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      grandTotalPurchase.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
