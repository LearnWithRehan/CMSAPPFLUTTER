import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/variety_day_data.dart';
import '../core/api/api_service.dart';
import '../widgets/variety_day_item.dart';

class VarietyWiseGraphScreen extends StatefulWidget {
  const VarietyWiseGraphScreen({super.key});

  @override
  State<VarietyWiseGraphScreen> createState() =>
      _VarietyWiseGraphScreenState();
}

class _VarietyWiseGraphScreenState extends State<VarietyWiseGraphScreen> {

  List<VarietyDayData> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final plantCode = sp.getString("PLANT_CODE") ?? "0";

      final data = await ApiService.fetchDailyVarietyWise(plantCode);

      setState(() {
        list = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text("Daily Variety Wise Cane Purchase"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Variety Wise Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return VarietyDayItem(item: list[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
