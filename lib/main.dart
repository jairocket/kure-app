import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch(selectedPage) {
      case SelectedPage.appointments:
        page = Placeholder();
      case SelectedPage.newAppointment:
        page = Placeholder();
      case SelectedPage.home:
        page = Placeholder();
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
                NavigationRailDestination(icon: Icon(Icons.access_time), label: Text("Consultas")),
                NavigationRailDestination(icon: Icon(Icons.assignment_add), label: Text("Agendar Consulta"))
              ], 
              selectedIndex: selectedPage.index,
              onDestinationSelected: (index) => setState(() {
                selectedPage = SelectedPage.values[index];
                print(selectedPage.name);
              },
              
            ),
              
            )
          ),
          Expanded(
            child: Container(
              child: page,
              
            )
          )
        ],
      ),
    );
  }   
  
}
