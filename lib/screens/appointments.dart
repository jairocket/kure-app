import 'package:flutter/material.dart';
import 'package:mobile/components/empty_state.dart';
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
    if(appState.loggedUser != null) {
      appState.setAppointmentsMapByDoctorId(appState.loggedUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.appointments.isEmpty) {
      return EmptyState();
    }
    
    return ListView.builder(
      itemCount: appState.appointments.length,
      itemBuilder: (context, index) {
        final appointment = appState.appointments[index];
        return ListTile(
          title: Text(appointment.patient_name),
          subtitle: Text("${appointment.date} ${appointment.time}"),
        );
      },
    );
  }
}
