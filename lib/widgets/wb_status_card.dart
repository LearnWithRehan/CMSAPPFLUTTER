import 'package:flutter/material.dart';
import '../models/wb_status_item.dart';

class WbStatusCard extends StatelessWidget {
  final WbStatusItem item;

  const WbStatusCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            expandedText("WBNo: ${item.wbNo}", Colors.indigo),
            expandedText("Status: ${item.gStatus}", Colors.black),
            expandedText(
              "Flag: ${item.wFlag}",
              item.wFlag == "Y" ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget expandedText(String text, Color color) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
