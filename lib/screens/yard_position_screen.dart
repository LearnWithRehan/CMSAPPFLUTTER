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
  String cartInYard = "0";
  String cartInDonga = "0";
  String cartPurNo = "0";
  String cartPurQty  = "00.00";

  String trolleyInYard = "0";
  String truckInYard = "0";

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _loadSelectedDate();   // ⏳ wait here
    await loadData();

    // 🔥 now date is available
    loadCartCount();
    loadCartCountDonga();
    loadCartPurchyNo();
    loadCartPurchyQty();
  }


  /// ================= LOAD PREF + PLANT =================
  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    final plantCode = sp.getString("PLANT_CODE");

    if (plantCode != null) {
      plantName = await ApiService.fetchPlantNameByCode(plantCode);
    }

    setState(() {});
  }

  /// ================= LOAD DATE =================
  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDate = prefs.getString("SELECTED_DATE") ?? "";
    setState(() {});
  }

  /// ================= CART COUNT API =================
  Future<void> loadCartCount() async {
    try {
      CartCountResponse res = await ApiService.getCartCount();

      if (res.success == 1) {
        setState(() {
          // ✅ index = 1 (InYard)
          cartInYard = res.total.toString();
        });
      }
    } catch (e) {
      debugPrint("Cart API Error: $e");
    }
  }


  Future<void> loadCartCountDonga() async {
    try {
      final res = await ApiService.getCartCountDonga();

      if (res.success == 1) {
        setState(() {
          // ✅ index = 2 (InDonga)
          cartInDonga = res.total.toString();
        });
      }
    } catch (e) {
      debugPrint("Cart InDonga Error: $e");
    }
  }


  Future<void> loadCartPurchyNo() async {
    try {
      if (selectedDate.isEmpty) return;

      final res =
      await ApiService.getCartPurchyNo(selectedDate);

      if (res.success == 1) {
        setState(() {
          // ✅ index = 3
          cartPurNo = res.total.toString();
        });
      }
    } catch (e) {
      debugPrint("Cart Purchy No Error: $e");
    }
  }


  Future<void> loadCartPurchyQty() async {
    try {
      if (selectedDate.isEmpty) return;

      final res =
      await ApiService.getCartPurchyQty(selectedDate);

      if (res.success == 1) {
        setState(() {
          cartPurQty = res.total.toStringAsFixed(2);
        });
      }
    } catch (e) {
      debugPrint("Cart Purchy Qty Error: $e");
    }
  }




  /// ================= UI HELPERS =================
  Widget cell(String text, {bool bold = false}) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget row(List<String> values, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: values.map((e) => cell(e, bold: bold)).toList(),
      ),
    );
  }

  Widget titleLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yard Position"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PLANT NAME
            Center(
              child: Text(
                plantName.isEmpty
                    ? "Cane Management System"
                    : plantName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// DATE
            Row(
              children: [
                const Expanded(
                  child: Text("Yard Position as on Date:"),
                ),
                Text(
                  selectedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(),

            /// HEADER
            row(
              ["Supply", "InYard", "InDonga", "Pur No", "TodayPur(Qty)"],
              bold: true,
            ),

            /// ================= AT GATE =================
            titleLine("----------- AT GATE -----------"),

            row([
              "Cart",
              cartInYard,      // 👈 API VALUE HERE
              cartInDonga,
              cartPurNo,
              cartPurQty,
            ]),

            row([
              "Trolley",
              trolleyInYard,
              "0",
              "0",
              "00.00",
            ]),

            row([
              "Truck",
              truckInYard,
              "0",
              "0",
              "00.00",
            ]),

            /// ================= CENTRE =================
            titleLine("------- CENTRE RECEIPT -------"),

            row([
              "Truck",
              "0",
              "0",
              "0",
              "0.0",
            ]),

            titleLine("==================================="),
            row(["Total", "00", "00", "00", "00.00"], bold: true),
            titleLine("==================================="),

            const SizedBox(height: 10),

            const Text(
              "Todate Purchase : 00.00",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
