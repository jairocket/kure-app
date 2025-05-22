import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueInfo extends StatelessWidget {
  final int totalConsultas;

  const RevenueInfo({super.key, required this.totalConsultas});

  @override
  Widget build(BuildContext context) {
    final double receita = totalConsultas * 300.0;
    final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Receita estimada", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            formatador.format(receita),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        switch (value.toInt()) {
                          case 0: return Text('Marcadas');
                          case 1: return Text('Previstas');
                          default: return Text('');
                        }
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: 120 * 300.0 / 1000, color: Colors.blue)],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 55 * 300.0 / 1000, color: Colors.green)],
                  ),
                ],
                gridData: FlGridData(show: true),
              ),
            ),
          )
        ],
      ),
    );
  }
}
