import 'package:canemanagementsystem/screens/yard_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowYardDataScreen extends StatefulWidget {
  const ShowYardDataScreen({Key? key}) : super(key: key);

  @override
  State<ShowYardDataScreen> createState() => _ShowYardDataScreenState();
}

class _ShowYardDataScreenState extends State<ShowYardDataScreen> {
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _setTodayDate();
  }

  /// ✅ Set current date
  void _setTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat("dd-MM-yyyy");
    selectedDate = formatter.format(now);
    setState(() {});
  }

  /// ✅ Open Date Picker
  Future<void> _openDatePicker() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formatter = DateFormat("dd-MM-yyyy");
      selectedDate = formatter.format(pickedDate);
      setState(() {});
    }
  }

  /// ✅ Process button click
  Future<void> _onProcess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("SELECTED_DATE", selectedDate);

    // 🔁 Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const YardPositionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔷 HEADER CARD
              Card(
                elevation: 6,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
                      Center(
                        child: Text(
                          "YARD REPORT",
                          style: const TextStyle(
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// DATE LABEL
                      const Text(
                        "Select Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444444),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// DATE PICKER BOX
                      InkWell(
                        onTap: _openDatePicker,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 22,
                                color: Color(0xFF444444),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                selectedDate,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔘 PROCESS BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _onProcess,
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "PROCESS",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
