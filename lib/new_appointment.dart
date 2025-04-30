import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/components/custom_time_picker.dart';
import 'package:mobile/components/date_input.dart';

class NewAppointmentsPage extends StatefulWidget {
  const NewAppointmentsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NewAppointmentsPageState();
}

final _patientNameController = TextEditingController();
final _appointmentDateController = TextEditingController();
final _appointmentTimeController = TextEditingController();

DateTime? _appointmentDate;
TimeOfDay? _appointmentTime;
String? _patientName;

class _NewAppointmentsPageState extends State<NewAppointmentsPage> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> _datePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    initializeDateFormatting("pt_BR", null);

    if (date != null) {
      setState(() {
        _appointmentDate = date;


        _appointmentDateController.text =
            "${date.day.toString().padLeft(2, '0')}/"
            "${date.month.toString().padLeft(2, '0')}/"
            "${date.year}";
      });
    }
  }

  void _timePicker() {
    final List<TimeOfDay> avaliableTimes = List.generate(
      20,
      (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height *
              0.95, 
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selecione um horário',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: avaliableTimes.length,
                  itemBuilder: (context, index) {
                    final horario = avaliableTimes[index];
                    final textoHorario =
                        "${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}";

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _appointmentTime = horario;
                          _appointmentTimeController.text = textoHorario;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        textoHorario,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  void _makeAppointment() {
    final isValid = _formKey.currentState!.validate();
    final dataSelecionada = _appointmentDate != null;
    final horaSelecionada = _appointmentTime != null;

    if (isValid && dataSelecionada && horaSelecionada) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Consulta agendada com sucesso!')));

      _cleanInputData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
    }
  }

  void _cleanInputData() {
    _formKey.currentState?.reset();
    _patientNameController.clear();
    _appointmentDateController.clear();
    _appointmentTimeController.clear();

    setState(() {
      _appointmentDate = null;
      _appointmentTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFormTitle(title: "Agendar Consulta"),
                    SizedBox(height: 30),
                    CustomTextInputField(
                      hintText: "Nome do paciente",
                      controller: _patientNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-ZÀ-ÿ\s]"),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Informe o nome do paciente";
                        }
                        return null;
                      },
                      onSaved:
                          (value) => setState(() {
                            if (value != null) {
                              _patientName = value;
                            }
                          }),
                    ),
                    SizedBox(height: 15),
                    CustomDateInput(
                      controller: _appointmentDateController,
                      labelText: 'Data da consulta',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Selecione uma data";
                        }
                        return null;
                      },
                      onTap: _datePicker,
                      onSaved: (_) {},
                    ),
                    SizedBox(height: 15),
                    CustomTimeInput(
                      controller: _appointmentTimeController,
                      labelText: 'Horário da consulta',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Selecione o horário";
                        }
                        return null;
                      },
                      onTap: _timePicker,
                      onSaved: (_) {},
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _makeAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D72F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Agendar Consulta",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                                       Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _cleanInputData,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 70,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(
                              color: const Color(0xFF2D72F6),
                              width: 2,
                            )
                          ),
                        ),
                        child: Text(
                          "Limpar campos",
                          style: TextStyle(fontSize: 16, color: const Color(0xFF2D72F6),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
