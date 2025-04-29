import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_gender_options.dart';
import 'package:mobile/components/date_input.dart';
import 'package:mobile/extensions/extensions.dart';
import 'package:mobile/services/database_service.dart';
import 'package:mobile/services/patient_service.dart';
import 'components/custom_text_input_field.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _cpfController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final TextEditingController _genderController = TextEditingController();

final _cpfFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

final _cellPhoneFormater = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  State<StatefulWidget> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? name, cpf, phoneNumber, gender, birthday;
  bool _showGenderWarning = false;

  Future<void> savePatient(name, cpf, phone, birthday, gender) async {
    final PatientService patientService = PatientService.instance;

    await patientService.savePatient(name, cpf, phone, birthday, gender);
  }

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1914),
      lastDate: DateTime.now(),
    );

    initializeDateFormatting("pt_BR", null);

    if (_picked != null) {
      setState(() {
        birthday = DateFormat.yMd("pt_BR").format(_picked);
        _birthdayController.text = DateFormat.yMd("pt_BR").format(_picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                  key: _formkey,
                  child: Column(
                    children: [
                      CustomFormTitle(title: "Cadastrar Paciente"),
                      SizedBox(height: 30),
                      CustomTextInputField(
                        hintText: "Digite o nome completo",
                        controller: _nameController,
                        inputFormatters: [],
                        validator: (value) {
                          if (!value!.isValidPatientName) {
                            return "Digite um nome válido";
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
                        onSaved:
                            (value) => setState(() {
                              cpf = value;
                            }),
                      ),
                      SizedBox(height: 15),
                      CustomTextInputField(
                        hintText: "Digite o telefone",
                        controller: _phoneController,
                        inputFormatters: [_cellPhoneFormater],
                        validator: (value) {
                          if (!value!.isValidPhone) {
                            return "Digite um número válido. Apenas números.";
                          }
                          return null;
                        },
                        onSaved:
                            (value) => setState(() {
                              phoneNumber = value;
                            }),
                      ),
                      SizedBox(height: 15),
                      CustomDateInput(
                        controller: _birthdayController,
                        labelText: 'Data de nascimento',
                        validator: (value) {
                          if (!value!.isValidPatientName) {
                            return "Selecione a data de nascimento";
                          }
                          return null;
                        },
                        onTap: selectDate,
                        onSaved: (value) => setState(() {}),
                      ),
                      SizedBox(height: 15),
                      GenderButton(
                        onChangedGenderButton: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),

                      if (_showGenderWarning)
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Escolha uma opção",
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 30),
                      MaterialButton(
                        onPressed: () {
                          if (gender == null) {
                            setState(() {
                              _showGenderWarning = true;
                            });
                          } else {
                            setState(() {
                              _showGenderWarning = false;
                            });
                          }
                          if (_formkey.currentState!.validate() &&
                              !_showGenderWarning) {
                            _formkey.currentState!.save();
                            savePatient(name!, cpf!, phoneNumber!, birthday!, gender!,)
                              .then(
                                (value) => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    content: Text('Paciente cadastrado com sucesso!'),
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ).catchError(
                                  (error) => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
                                      content: Text('Paciente já cadastrado.'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  ),
                                );
                            _formkey.currentState!.reset();
                            _nameController.clear();
                            _cpfController.clear();
                            _phoneController.clear();
                            _birthdayController.clear();
                            _genderController.clear();
                            setState(() {
                              name = null;
                              cpf = null;
                              phoneNumber = null;
                              gender = null;
                              birthday = null;
                            });
                          }
                        },
                        color: Color(0xFF2D72F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            "Salvar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1.5,
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
      ),
    );
  }
}
