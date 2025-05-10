
import 'package:flutter/cupertino.dart';
import 'package:mobile/models/appointment.dart';
import 'package:mobile/services/appointments_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    print(appState.appointments);


      return Container();
  }
  
}