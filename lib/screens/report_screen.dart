import 'package:flutter/material.dart';
import 'package:kure/main.dart';
import 'package:kure/models/appointmentData.dart';
import 'package:provider/provider.dart';
import '../components/chart_pie_widget.dart';
import '../components/dashboard_card.dart';
import '../components/revenue_info.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    if (appState.loggedUser != null) {
      appState.setAppointmentDataList(appState.loggedUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    List<AppointmentData> billedAppointments = appState.getBilledAppointments();
    List<AppointmentData> scheduledAppointments = appState.getScheduledAppointments();
    List<AppointmentData> cancelledAppointments = appState.getCancelledAppointments();

    List<double> billedPriceMap = billedAppointments.map((bill) => bill.price).toList();
    double totalBilledRevenue = billedAppointments
        .isEmpty ? 0.00 : billedPriceMap.reduce((value, price) => value + price);

    List<double> scheduledPriceMap = scheduledAppointments.map((bill)=> bill.price).toList();
    double totalScheduledRevenue = scheduledAppointments
        .isEmpty ? 0.00 : scheduledPriceMap.reduce((value, price) => value + price);

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
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "Atualizado dia "+ "${DateTime.now().toLocal().day}/${DateTime.now().toLocal().month}/${DateTime.now().toLocal().year}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flex(
                direction: Axis.horizontal,
                children: [
                    Expanded(
                        child: DashboardCard(
                          value: billedAppointments.length,
                          label: "Consultas Faturadas",
                          icon: Icons.calendar_month,
                          color: Colors.blue,
                          ontap: () => appState.setSelectedPage(SelectedPage.billedAppointments),
                        ),
                    ),
                    Expanded(
                      child: DashboardCard(
                          value: scheduledAppointments.length,
                          label: "Consultas Previstas",
                          icon: Icons.remove_red_eye,
                          color: Colors.green,
                          ontap: () => appState.setSelectedPage(SelectedPage.scheduledAppointments),
                        ),
                    ),
                    Expanded(
                      child: DashboardCard(
                          value: cancelledAppointments.length,
                          label: "Consultas Canceladas",
                          icon: Icons.cancel,
                          color: Colors.red,
                          ontap: () => appState.setSelectedPage(SelectedPage.cancelledAppointments),
                        ),
                    )
                ],
              ),
              const SizedBox(height: 20),
              ChartPieWidget(
                marcadas: billedAppointments.length,
                previstas: scheduledAppointments.length,
                canceladas: cancelledAppointments.length,
              ),
              const SizedBox(height: 20),
              RevenueInfo(
                  billedRevenue: totalBilledRevenue,
                  scheduledRevenue:  totalScheduledRevenue),
            ],
          ),
        ),
      ),
    );
  }
}
