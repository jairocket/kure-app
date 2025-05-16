import 'package:flutter/material.dart';
import 'package:mobile/components/custom_title.dart';
import 'package:mobile/components/empty_state.dart';
import 'package:mobile/models/appointment.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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

  Widget _buildTile(Appointment appointment) {
    return ListTile(
      title: Container(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Nome",
                      style: TextStyle(color: Colors.grey.shade700, wordSpacing: 2)
                  ),
                  Text(
                      appointment.patient_name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  )
                ],
              ),
            ),
            SizedBox(width: 3),
            Icon(size: 18, Icons.access_time_filled, color: const Color(0xFF2D72F6)),
            SizedBox(width: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Horário",
                      style: TextStyle(color: Colors.grey.shade700, wordSpacing: 2),
                  ),
                  Text(
                      appointment.time,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  )
                ],
            ),
            IconButton(
              iconSize: 20,
              onPressed: () => {},
              icon: const Icon(
                Icons.edit_calendar_outlined,
                color: const Color(0xFF2D72F6),
              ),
            ),
            IconButton(
              iconSize: 20,
              onPressed: () => {},
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
            ),
            Divider()
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
        SizedBox(height: 15),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(2.4, 0, 0, 10),
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
