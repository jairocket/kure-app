import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPieWidget extends StatelessWidget {
  final int marcadas;
  final int previstas;
  final int canceladas;

  const ChartPieWidget({
    super.key,
    required this.marcadas,
    required this.previstas,
    required this.canceladas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Distribuição de consultas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: marcadas.toDouble(),
                    title: '',
                    radius: 50,
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: previstas.toDouble(),
                    title: '',
                    radius: 50,
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: canceladas.toDouble(),
                    title: '',
                    radius: 50,
                  ),
                ],
                sectionsSpace: 0,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildLegend("Consultas Marcadas", Colors.blue),
                _buildLegend("Consultas Previstas", Colors.green),
                _buildLegend("Consultas Canceladas", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: color, radius: 6),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
