import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/centre_day_item.dart';
import '../widgets/date_card.dart';

class CentreVarietySummaryGraphScreen extends StatefulWidget {
  const CentreVarietySummaryGraphScreen({super.key});

  @override
  State<CentreVarietySummaryGraphScreen> createState() =>
      _CentreVarietySummaryGraphScreenState();
}

class _CentreVarietySummaryGraphScreenState
    extends State<CentreVarietySummaryGraphScreen> {
  bool loading = true;

  final List<String> dateList = [];
  final Map<String, List<CentreDayItem>> map = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    /// 🔥 PLANT CODE FROM PREFS
    final plantCode = await Prefs.getPlantCode();

    final list =
    await ApiService.fetchCentreDayWise(plantCode);

    map.clear();
    dateList.clear();

    for (var item in list) {
      if (!map.containsKey(item.reportDate)) {
        map[item.reportDate] = [];
        dateList.add(item.reportDate);
      }
      map[item.reportDate]!.add(item);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Centre Variety Summary"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF134E5E), Color(0xFF71B280)],
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: dateList.length,
        itemBuilder: (_, i) {
          final date = dateList[i];
          return DateCard(
            date: date,
            list: map[date]!,
          );
        },
      ),
    );
  }
}
