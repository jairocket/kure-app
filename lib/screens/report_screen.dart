import 'package:flutter/material.dart';
import '../components/chart_pie_widget.dart';
import '../components/dashboard_card.dart';
import '../components/revenue_info.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int marcadas = 120;
    const int previstas = 55;
    const int canceladas = 20;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Relatório Geral',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 6),
                  Text("Atualizado dia 11/04/2025", style: TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  DashboardCard(
                    value: marcadas,
                    label: "Consultas Marcadas",
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  DashboardCard(
                    value: previstas,
                    label: "Consultas Previstas",
                    icon: Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                  DashboardCard(
                    value: canceladas,
                    label: "Consultas Canceladas",
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ChartPieWidget(
                marcadas: marcadas,
                previstas: previstas,
                canceladas: canceladas,
              ),
              const SizedBox(height: 20),
              const RevenueInfo(
                totalConsultas: marcadas + previstas,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
