import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/login.dart';
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
        title: "Meu App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey)
        ),
        home: MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

enum SelectedPage {
  home,
  appointments,
  newAppointment
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedPage = SelectedPage.appointments;
  var loginPage = LoginPage();
  var patientFormPage = PatientForm();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;

    switch(selectedPage) {
      case SelectedPage.home:
        page = loginPage;
      case SelectedPage.appointments:
        page = patientFormPage;
      case SelectedPage.newAppointment:
        page = Placeholder();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: appState.navigationBarToggle,
            icon: Icon(Icons.menu),
            padding: EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label: Text("Home")
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.access_time), 
                    label: Text("Consultas")
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.assignment_add),
                    label: Text("Agendar Consulta")
                  )
                ], 
                selectedIndex: selectedPage.index,
                onDestinationSelected: (index) => setState(() {
                  selectedPage = SelectedPage.values[index];
                  print(selectedPage.name);
                },
              ), 
              extended: appState.isExpanded, 
            )
          ),
          Expanded(child: Container(child: page,))
        ],
      ),
        
    );
  
  }   
  
}


  


