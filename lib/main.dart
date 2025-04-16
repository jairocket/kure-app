import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/login.dart';
import 'package:mobile/patient_form.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  runApp(const MainApp());

  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'k_database.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE patient(id INTEGER PRIMARY KEY, name TEXT, cpf TEXT, phone TEXT, birthday DATE)',
      );
    },
    version: 1,
  );
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
  var loginPage = LoginPage();
  var patientFormPage = PatientForm();

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedPage) {
      case SelectedPage.home:
        page = loginPage;
      case SelectedPage.appointments:
        page = Placeholder();
      case SelectedPage.newAppointment:
        page = Placeholder();
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
