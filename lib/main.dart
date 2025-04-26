import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'patient_form.dart';
import 'scheduled_appointments.dart';
import 'doctor_form.dart';
import 'report_screen.dart';

void main() {
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
        title: "Meu App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        // 👇 Inicializa direto na tela de Login
        home: const LoginPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var isExpanded = false;

  void navigationBarToggle() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}

// Esta tela aqui (MyHomePage) agora é usada somente **depois** do login
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum SelectedPage {
  cadastrarPaciente,
  cadastrarMedico,
  marcarConsulta,
  relatorio,
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedPage = SelectedPage.cadastrarPaciente;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;

    switch (selectedPage) {
      case SelectedPage.cadastrarPaciente:
        page = const PatientForm();
        break;
      case SelectedPage.cadastrarMedico:
        page = const DoctorForm();
        break;
      case SelectedPage.marcarConsulta:
        page = const ScheduleAppointmentPage();
        break;
      case SelectedPage.relatorio:
        page = const ReportScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel'),
        leading: IconButton(
          onPressed: appState.navigationBarToggle,
          icon: const Icon(Icons.menu),
        ),
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedPage.index,
              onDestinationSelected: (index) {
                setState(() {
                  selectedPage = SelectedPage.values[index];
                });
              },
              extended: appState.isExpanded,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person_add),
                  label: Text("Cadastrar Paciente"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.medical_services),
                  label: Text("Cadastrar Médico"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_available),
                  label: Text("Marcar Consulta"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Relatório"),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: page),
        ],
      ),
    );
  }
}
