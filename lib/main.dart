import 'package:flutter/material.dart';
import 'package:mobile/consulta.dart';
import 'package:mobile/login_form.java.dart';
import 'package:provider/provider.dart';
import 'package:mobile/patient_form.dart';


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

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

enum SelectedPage { home, appointments, newAppointment, newPatient }

class _MyHomePageState extends State<MyHomePage> {
  var selectedPage = SelectedPage.home;
  var loginPage = LoginForm();
  var patientFormPage = PatientForm();
  var appointmentFormPage = AgendamentoConsultaPage();

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedPage) {
      case SelectedPage.home:
        page = loginPage;
      case SelectedPage.appointments:
        page = Placeholder();
      case SelectedPage.newAppointment:
        page = appointmentFormPage;
      case SelectedPage.newPatient:
        page = patientFormPage;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: Icon(Icons.menu),
              padding: EdgeInsets.symmetric(horizontal: 30),
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
                  leading: Icon(Icons.home),
                  onTap:
                      () => setState(() {
                        selectedPage = SelectedPage.home;
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Cadastrar Paciente"),
                  leading: Icon(Icons.person_add),
                  onTap:
                      () => setState(() {
                        selectedPage = SelectedPage.newPatient;
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Nova Consulta"),
                  leading: Icon(Icons.assignment_add),
                  onTap:
                      () => setState(() {
                        selectedPage = SelectedPage.newAppointment;
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
                ListTile(
                  title: Text("Consultas"),
                  leading: Icon(Icons.access_time),
                  onTap:
                      () => setState(() {
                        selectedPage = SelectedPage.appointments;
                        Scaffold.of(context).closeDrawer();
                      }),
                ),
              ],
            ),
          );
        },
      ),

      body: Column(children: [Expanded(child: page)]),
    );
  }
}
