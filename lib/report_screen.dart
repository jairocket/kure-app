import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F1),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Seja bem vindo, ${appState.loggedUser!.name}!"),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Relatório',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}