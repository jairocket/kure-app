import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:kure/components/custom_time_picker_modal.dart';
import 'package:kure/components/custom_title.dart';
import 'package:kure/components/custom_text_input_field.dart';
import 'package:kure/components/custom_time_picker.dart';
import 'package:kure/components/date_input.dart';
import 'package:kure/extensions/extensions.dart';
import 'package:kure/services/appointments_service.dart';
import 'package:kure/services/patient_service.dart';
import 'package:provider/provider.dart';
import 'package:currency_textfield/currency_textfield.dart';

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

DateTime? appointmentDate;
TimeOfDay? appointmentTime;
String? name, cpf;
int? patients_id, doctors_id, priceInCents;

class _NewAppointmentsPageState extends State<NewAppointmentsPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isClearing = false;

  final _patientNameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _appointmentDateController = TextEditingController();
  final _appointmentTimeController = TextEditingController();
  final _currencyController = CurrencyTextFieldController(
    currencySymbol: "R\$",
    decimalSymbol: ",",
    thousandSymbol: ".",
  );

  Future<void> saveAppointment(loggedUserId, date, time, priceInCents) async {
    if (loggedUserId == null) {
      throw Exception("É preciso estar logado para agendar uma consulta");
    }

    if (patients_id == null) {
      throw Exception("Indique um paciente");
    }

    final AppointmentsService patientService = AppointmentsService.instance;
    await patientService.saveAppointment(
      loggedUserId,
      patients_id!,
      date,
      time,
      priceInCents,
    );
  }

  Future<void> _fetchPatientData(String cleanCpf) async {
    final PatientService patientService = PatientService.instance;
    try {
      Map<String, Object?> patientData = await patientService
          .getPatientDataByCpf(cleanCpf);
      if (patientData["name"] != null) {
        setState(() {
          name = patientData["name"] as String;
          patients_id = patientData["id"] as int;
          _patientNameController.text = patientData["name"] as String;
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

  String formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _datePicker() async {
    await initializeDateFormatting('pt_BR', null);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        appointmentDate = selectedDate;
        _appointmentDateController.text = DateFormat.yMd(
          "pt_BR",
        ).format(selectedDate);
      });
    }
  }

  void _cleanInputData() {
    isClearing = true;

    _formKey.currentState?.reset();
    _cpfController.clear();
    _patientNameController.clear();
    _appointmentDateController.clear();
    _appointmentTimeController.clear();
    _currencyController.clear();

    setState(() {
      patients_id = null;
      name = null;
      cpf = null;
      appointmentDate = null;
      appointmentTime = null;
      priceInCents = null;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      isClearing = false;
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
                    CustomTitle(title: "Agendar Consulta"),
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
                        if (isClearing) return;
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
                      onTap: () {
                        if (appointmentDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecione a data primeiro.',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        CustomTimePickerModal.show(
                          context: context,
                          date: formatDate(appointmentDate!),
                          onTimeSelected: (selectedTime) {
                            setState(() {
                              appointmentTime = TimeOfDay(
                                hour: int.parse(selectedTime.split(':')[0]),
                                minute: int.parse(selectedTime.split(':')[1]),
                              );
                              _appointmentTimeController.text = selectedTime;
                            });
                            _formKey.currentState?.validate();
                          },
                        );
                      },
                      onSaved: (_) {},
                    ),
                    SizedBox(height: 15),
                    CustomTextInputField(
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      hintText: "Valor da consulta",
                      controller: _currencyController,
                      validator: (value) {
                        if (value == "") {
                          return "Informe o valor da consulta";
                        }
                        if (_currencyController.intValue < 0) {
                          return "Consulta não pode ser menor que zero";
                        }
                        return null;
                      },
                      onSaved:
                          (value) => {
                            priceInCents = _currencyController.intValue,
                          },
                      inputFormatters: [],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        _cleanInputData;
                      },
                      child: const Text("Limpar campos", style: TextStyle(color:  const Color(0xFF2D72F6), fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          _formKey.currentState!.save();
                          saveAppointment(
                                loggedUserId,
                                formatDate(appointmentDate!),
                                formatTime(appointmentTime!),
                                priceInCents!,
                              )
                              .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Consulta agendada com sucesso!',
                                    ),
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
