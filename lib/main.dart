import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/appointmentData.dart';
import 'package:mobile/models/doctor.dart';
import 'package:mobile/screens/appointments.dart';
import 'package:mobile/screens/new_appointment.dart';
import 'package:mobile/screens/doctor_form.dart';
import 'package:mobile/screens/login_form.java.dart';
import 'package:mobile/screens/report_screen.dart';
import 'package:mobile/screens/updateAppointment.dart';
import 'package:mobile/services/appointments_service.dart';
import 'package:mobile/services/doctor_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/screens/patient_form.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_io/io.dart';

import 'models/appointment.dart';

void main() {
  if(!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginForm(),
          '/newDoctor': (context) => DoctorForm(),
        },
        title: "Kure App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPage = SelectedPage.home;
  void setSelectedPage(SelectedPage newPage){
    selectedPage = newPage;
    notifyListeners();
  }

  LoggedDoctor? loggedUser = null;
  Future<void> setLoggedUser(String email, String password) async {
    final DoctorService _doctorService = DoctorService.instance;

    try {
      Map<String,Object?> doctor = await _doctorService.logIn(email, password);

      if(doctor["id"] != null){
        loggedUser = LoggedDoctor(doctor["id"] as int, doctor["name"] as String, doctor["crm"] as String);
        selectedPage = SelectedPage.home;
        notifyListeners();
      }
    } catch(e) {
      rethrow;
    }
  }

  void logout() {
    loggedUser = null;
    notifyListeners();
  }

  List<AppointmentData> appointmentDataList = List.empty(growable: true);

    Future<void> setAppointmentDataList(int loggedUserId) async {
    final AppointmentsService appointmentsService =
        AppointmentsService.instance;

    var appointmentsMap = await appointmentsService.getAllAppointments(
      loggedUserId,
    );

   appointmentDataList = appointmentsMap.map((appointment) {
      int price_in_cents = appointment["price_in_cents"] as int;
      double price = price_in_cents / 100;

      int cancelledInt = appointment["cancelled"] as int;
      bool cancelled = (cancelledInt == 1);

      return AppointmentData(
        appointment["date"] as String,
        cancelled,
        price,
      );
    }).toList();

    notifyListeners();
  }


  Future<void> setAppointmentsMapByDoctorId(int doctorId) async {
    final AppointmentsService appointmentsService = AppointmentsService.instance;
     var appointmentsMap = await appointmentsService.getTodayNotCancelledAppointments(doctorId);
       appointments = appointmentsMap.map(
              (appointment) => Appointment(
              appointment["id"] as int,
              appointment["patient_name"] as String,
              appointment["time"] as String,
              appointment["date"] as String,
              (appointment["cancelled"] == 1)
          )
      ).toList();
       notifyListeners();
  }


  List<Appointment> appointments = List<Appointment>.empty(growable: true);

  int? appointmentIdToUpdate;
  void setAppointmentIdToUpdate(int appointmentId){
    appointmentIdToUpdate = appointmentId;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

enum SelectedPage { 
  home, 
  newAppointment,
  newPatient,
  doctorForm,
  reportScreen,
  updateAppointment
}

class _MyHomePageState extends State<MyHomePage> {
  var loginPage = LoginForm();
  var patientFormPage = PatientForm();
  var appointmentFormPage = NewAppointmentsPage();
  var doctorForm = DoctorForm();
  var reportScreen = ReportScreen();
  var appointments = AppointmentsPage();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var selectedPage = appState.selectedPage;

  //appState.loggedUser = LoggedDoctor(1, "jai", "12345");

    Widget page;
  
    switch (selectedPage) {
      case SelectedPage.home:
        page = appState.loggedUser != null ? appointments  : LoginForm() ;
      case SelectedPage.newAppointment:
        page = appointmentFormPage;
      case SelectedPage.newPatient:
        page = patientFormPage;
      case SelectedPage.doctorForm:
        page = doctorForm;
      case SelectedPage.reportScreen:
        page = reportScreen;
      case SelectedPage.updateAppointment:
        page = UpdateAppointment(appointmentId: appState.appointmentIdToUpdate!);
    }
    if(appState.loggedUser == null){
      return LoginForm();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: Icon(Icons.menu, color: const Color(0xFF2D72F6), size: 40),
            );
          },
        ),
      ),
      drawer: Builder(
        builder: (context) {
          return Drawer(
            child: ListView(
              children: [
                const DrawerHeader(child: Text("Menu")),
                ListTile(
                  title: Text("Home"),
                  leading: Icon(Icons.home, color: const Color(0xFF2D72F6)),
                  onTap:
                      () => setState(() {
                        appState.setSelectedPage(SelectedPage.home);
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Cadastrar Paciente"),
                  leading: Icon(Icons.person_add, color: const Color(0xFF2D72F6)),
                  onTap:
                      () => setState(() {
                        appState.setSelectedPage(SelectedPage.newPatient);
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Nova Consulta"),
                  leading: Icon(Icons.assignment_add, color: const Color(0xFF2D72F6)),
                  onTap:
                      () => setState(() {
                        appState.setSelectedPage(SelectedPage.newAppointment);
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Relatório"),
                  leading: Icon(Icons.report, color: const Color(0xFF2D72F6)),
                  onTap:
                    () => setState(() {
                      appState.setSelectedPage(SelectedPage.reportScreen);
                      Scaffold.of(context).closeDrawer();
                    }),
                ),
                ListTile(
                  title: Text("Sair"),
                  leading: Icon(Icons.exit_to_app, color: const Color(0xFF2D72F6)),
                  onTap: () => setState(() {
                    appState.loggedUser = null;
                    Scaffold.of(context).closeDrawer();
                  })
                )
              ],
            ),
          );
        },
      ),
      body: Column(children: [Expanded(child: page)]),
    );
  }
}
