import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kure/components/custom_title.dart';
import 'package:kure/components/empty_state.dart';
import 'package:kure/models/appointmentData.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/appointments_service.dart';

class AppointmentListPage extends StatelessWidget {
  final List<AppointmentData> appointments;
  final String title;

  AppointmentListPage({super.key, required this.appointments, required this.title});
  final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  Future<void> cancelAppointmentById(int id) async {
    final AppointmentsService appointmentsService = AppointmentsService.instance;
    await appointmentsService.cancelAppointmentById(id);
  }

  Widget _buildTile(AppointmentData appointment, BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListTile(
      hoverColor: Colors.grey,
      minTileHeight: 100,
      title: Container(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Paciente",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      wordSpacing: 2,
                    ),
                  ),
                  Text(
                    appointment.patientName.split(" ").first,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Data",
                  style: TextStyle(color: Colors.grey.shade700, wordSpacing: 2),
                ),
                Text(
                  "${appointment.date.split("-").last}/${appointment.date.split("-")[1]}/${appointment.date.split("-").first}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(width: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Valor",
                  style: TextStyle(color: Colors.grey.shade700, wordSpacing: 2),
                ),
                Text(
                  currencyFormatter.format(appointment.price),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            IconButton(
              disabledColor: Colors.grey,
              iconSize: 35,
              onPressed: appointment.cancelled ? null : () async => {
                await cancelAppointmentById(appointment.id),
                await appState.setAppointmentsMapByDoctorId(appState.loggedUser!.id)
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                color: appointment.cancelled ? Colors.grey: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyState(title: "Nada para mostrar aqui");
    }

    List<Widget> appointmentList =
        appointments
            .map((appointment) => _buildTile(appointment, context))
            .toList();

    return Column(
      children: [
        CustomTitle(title: title),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return appointmentList[index];
              },
            ),
          ),
        ),
      ],
    );
  }
}
