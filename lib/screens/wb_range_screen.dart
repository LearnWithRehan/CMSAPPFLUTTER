import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/storage/app_storage.dart';
import '../models/wb_range_item.dart';

class WbRangeScreen extends StatefulWidget {
  const WbRangeScreen({Key? key}) : super(key: key);

  @override
  State<WbRangeScreen> createState() => _WbRangeScreenState();
}

class _WbRangeScreenState extends State<WbRangeScreen> {
  List<WbRangeItem> list = [];
  bool loading = false;
  String plantCode = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    plantCode = await Prefs.getPlantCode();
    if (plantCode.isEmpty) {
      _msg("Plant code missing");
      return;
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);
    try {
      list = await ApiService.getWbRange(plantCode);
    } catch (e) {
      _msg(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _saveAll() async {
    if (list.isEmpty) {
      _msg("No data to save");
      return;
    }

    setState(() => loading = true);
    try {
      final msg = await ApiService.saveWbRange(plantCode, list);
      _msg(msg);
      _loadData();
    } catch (e) {
      _msg(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("WB RANGE"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520, // 🔹 tablet + mobile perfect
                ),
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// TITLE
                        const Text(
                          "WB RANGE CONFIGURATION",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (_, i) => _rowCard(list[i]),
                        ),

                        const SizedBox(height: 18),

                        /// SAVE BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _saveAll,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade700,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            child: const Text("SAVE ALL"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// LOADING OVERLAY
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  /// ================= ROW CARD =================
  Widget _rowCard(WbRangeItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Max WT",
                  isDense: true,
                  filled: true,
                  fillColor: Color(0xFFF8FAFC),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: item.wMaxWt),
                onChanged: (v) => item.wMaxWt = v,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Adj WT",
                  isDense: true,
                  filled: true,
                  fillColor: Color(0xFFF8FAFC),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: item.wAdjWt),
                onChanged: (v) => item.wAdjWt = v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
