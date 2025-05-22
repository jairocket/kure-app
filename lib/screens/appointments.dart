import 'package:flutter/material.dart';
import 'package:mobile/components/custom_title.dart';
import 'package:mobile/components/empty_state.dart';
import 'package:mobile/models/appointment.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/appointments_service.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    if (appState.loggedUser != null) {
      appState.setAppointmentsMapByDoctorId(appState.loggedUser!.id);
    }
  }

  Future<void> cancelAppointmentById(int id) async {
    final AppointmentsService appointmentsService = AppointmentsService.instance;
    await appointmentsService.cancelAppointmentById(id);
  }

  Widget _buildTile(Appointment appointment) {
    var appState = context.read<MyAppState>();

    return ListTile(
      onTap: () => {
        appState.setAppointmentIdToUpdate(appointment.id),
        appState.setSelectedPage(SelectedPage.updateAppointment),
      },
      minTileHeight: 80,
      leading: Icon(
        size: 30,
        Icons.access_time_filled,
        color: const Color(0xFF2D72F6),
      ),
      title: Container(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 175,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nome",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      wordSpacing: 2,
                    ),
                  ),
                  Text(
                    appointment.patient_name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(width: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Horário",
                  style: TextStyle(color: Colors.grey.shade700, wordSpacing: 2),
                ),
                Text(
                  appointment.time,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(width: 10),
            IconButton(
              iconSize: 30,
              onPressed: () async => {
                await cancelAppointmentById(appointment.id)
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.appointments.isEmpty) {
      return EmptyState();
    }

    List<Widget> appointmentList =
        appState.appointments
            .map((appointment) => _buildTile(appointment))
            .toList();

    return Column(
      children: [
        CustomTitle(title: "Consultas Marcadas"),
        SizedBox(
          height: 50,
          child: Text(
           '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16),
          )
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
              itemCount: appState.appointments.length,
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
