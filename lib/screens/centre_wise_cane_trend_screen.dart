import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_service.dart';
import '../models/day_wise_centre_graph_model.dart';
import '../widgets/day_wise_centre_graph_bar_widget.dart';

class DayWiseCentreGraphScreen extends StatefulWidget {
  const DayWiseCentreGraphScreen({super.key});

  @override
  State<DayWiseCentreGraphScreen> createState() =>
      _DayWiseCentreGraphScreenState();
}

class _DayWiseCentreGraphScreenState
    extends State<DayWiseCentreGraphScreen> {

  List<DayWiseCentreGraphModel> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final plantCode = sp.getString("PLANT_CODE") ?? "";

      list = await ApiService
          .fetchDayWiseCentreGraph(plantCode);
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Daily Centre Wise Cane Purchase"),
      ),
      body: loading
          ? const Center(
          child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return DayWiseCentreGraphBarWidget(
            data: list[index],
          );
        },
      ),
    );
  }
}
