import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/components/custom_time_picker.dart';
import 'package:mobile/components/date_input.dart';
import 'package:mobile/extensions/extensions.dart';
import 'package:mobile/services/appointments_service.dart';
import 'package:mobile/services/patient_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';

final _cpfFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

class NewAppointmentsPage extends StatefulWidget {
  const NewAppointmentsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NewAppointmentsPageState();
}

final _patientNameController = TextEditingController();
final _cpfController = TextEditingController();
final _appointmentDateController = TextEditingController();
final _appointmentTimeController = TextEditingController();

String? name, cpf, date, time;
int? patients_id, doctors_id;

class _NewAppointmentsPageState extends State<NewAppointmentsPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> saveAppointment(loggedUserId, date, time) async {
    if(loggedUserId == null) {
      throw Exception("É preciso estar logado para agendar uma consulta");
    }

    if(patients_id == null) {
      throw Exception("Indique um paciente");
    }

    final AppointmentsService patientService = AppointmentsService.instance;

    await patientService.saveAppointment(loggedUserId, patients_id!, date, time);
  }

  Future<void> _fetchPatientData(String cleanCpf) async {
    final PatientService patientService = PatientService.instance;
    try {
      Map<String,Object?> patientData = await patientService.getPatientDataByCpf(cleanCpf);
      if (patientData["name"] != null) {
        setState(() {
          name = patientData["name"] as String;
          patients_id = patientData["id"] as int;
          _patientNameController.text = patientData["name"] as String;;
          cpf = cleanCpf;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Paciente ainda não foi cadastrado. Por favor efetue o cadastro ou confira o CPF antes de tentar novamente',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar o paciente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _datePicker() async {
    DateTime? appointmentDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    initializeDateFormatting("pt_BR", null);

    if (appointmentDate != null) {
      setState(() {
        date = DateFormat.yMd("pt_BR").format(appointmentDate);
        _appointmentDateController.text = DateFormat.yMd(
          "pt_BR",
        ).format(appointmentDate);
      });
    }
  }

  void _timePicker() {
    final List<TimeOfDay> availableTimes = List.generate(
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
          height: MediaQuery.of(context).size.height * 0.95,
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
                  itemCount: availableTimes.length,
                  itemBuilder: (context, index) {
                    final timeTable = availableTimes[index];
                    final timeTableText =
                        "${timeTable.hour.toString().padLeft(2, '0')}:${timeTable.minute.toString().padLeft(2, '0')}";

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          time = timeTableText;
                          _appointmentTimeController.text = timeTableText;
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
                        timeTableText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _cleanInputData() {
    _formKey.currentState?.reset();
    _cpfController.clear();
    _patientNameController.clear();
    _appointmentDateController.clear();
    _appointmentTimeController.clear();

    setState(() {
      patients_id = null;
      name = null;
      cpf = null;
      date = null;
      time = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int? loggedUserId = appState.loggedUser?.id;

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
                      readOnly: true,
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
                              name = value;
                            }
                          }),
                    ),

                    SizedBox(height: 15),
                    CustomTextInputField(
                      hintText: "Digite o CPF",
                      controller: _cpfController,
                      validator: (value) {
                        if (!value!.isCPFValid) {
                          return "Digite um CPF válido. Apenas números.";
                        }
                        return null;
                      },
                      inputFormatters: [_cpfFormatter],
                      onChanged: (value) {
                        final cleanCpf = value.replaceAll(RegExp(r'\D'), '');

                        if (cleanCpf.length == 11) {
                          final maskedCpf = _cpfFormatter.maskText(cleanCpf);
                          _fetchPatientData(maskedCpf);
                        } else {
                          setState(() {
                            name = null;
                            _patientNameController.clear();
                          });
                        }
                      },
                      onSaved: (value) {
                        cpf = value;
                      },
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
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          _formKey.currentState!.save();
                          saveAppointment(loggedUserId, date!, time!)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Consulta agendada com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            _cleanInputData();
                          })
                              .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          });
                        }
                      },
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
                            ),
                          ),
                        ),
                        child: Text(
                          "Limpar campos",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF2D72F6),
                          ),
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
