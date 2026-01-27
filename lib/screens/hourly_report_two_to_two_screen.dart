import 'package:flutter/material.dart';

class HourlyReportTwoToTwoScreen extends StatelessWidget {
  const HourlyReportTwoToTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hourly Report 2 To 2"),
      ),
      body: const Center(
        child: Text(
          "Hourly Report Two To Two Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
