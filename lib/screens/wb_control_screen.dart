import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_service.dart';
import '../models/wb_status_item.dart';
import '../widgets/wb_status_card.dart';

class WbControlScreen extends StatefulWidget {
  const WbControlScreen({super.key});

  @override
  State<WbControlScreen> createState() => _WbControlScreenState();
}

class _WbControlScreenState extends State<WbControlScreen> {
  String plantCode = "";
  List<String> wbList = ["Select WB No"];
  String selectedWb = "Select WB No";

  List<String> flagList = ["Select Flag", "Y", "N"];
  String selectedFlag = "Select Flag";

  List<WbStatusItem> statusList = [];
  String gateStatus = "";
  String wbFlag = "";

  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadInit();
  }

  Future<void> loadInit() async {
    final sp = await SharedPreferences.getInstance();
    plantCode = sp.getString("PLANT_CODE") ?? "";

    wbList.addAll(await ApiService.getWbNoList(plantCode));
    loadStatusList();

    timer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => loadStatusList(),
    );

    setState(() {});
  }

  Future<void> loadStatusList() async {
    statusList = await ApiService.getWbStatusList(plantCode);
    setState(() {});
  }

  Future<void> loadDetails(String wb) async {
    final data = await ApiService.getWbControlDetails(plantCode, wb);
    if (data != null) {
      gateStatus = data.gStatus;
      wbFlag = data.wFlag;
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Weighbridge Control"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520, // 🔥 screen centre card width
            ),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🔷 TITLE
                    const Text(
                      "Weighbridge Control Panel",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    /// 🔹 WB STATUS LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: statusList.length,
                      itemBuilder: (_, i) =>
                          WbStatusCard(item: statusList[i]),
                    ),

                    const SizedBox(height: 20),

                    /// 🔽 WB NO DROPDOWN
                    dropdown(
                      value: selectedWb,
                      list: wbList,
                      hint: "Select Weighbridge No",
                      onChanged: (v) {
                        selectedWb = v!;
                        if (v != "Select WB No") loadDetails(v);
                      },
                    ),

                    if (selectedWb != "Select WB No") ...[
                      const SizedBox(height: 16),

                      /// 🔽 FLAG DROPDOWN
                      dropdown(
                        value: selectedFlag,
                        list: flagList,
                        hint: "Select WB Flag",
                        onChanged: (v) {
                          selectedFlag = v!;
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 16),

                      /// 📋 STATUS BOX
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.indigo.shade100,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "WB No : $selectedWb",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Gate Status : $gateStatus"),
                            Text("WB Flag : $wbFlag"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ✅ UPDATE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white, // ✅ TEXT COLOR FIX
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () async {
                            final msg = await ApiService.updateWbFlag(
                              plantCode,
                              selectedWb,
                              selectedFlag,
                            );
                            loadDetails(selectedWb);
                            loadStatusList();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          },
                          child: const Text(
                            "Update Weighbridge",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget dropdown({
    required String value,
    required List<String> list,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: list
          .map((e) =>
          DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
