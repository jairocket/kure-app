import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kure/components/custom_title.dart';
import 'package:kure/components/custom_gender_options.dart';
import 'package:kure/components/date_input.dart';
import 'package:kure/extensions/extensions.dart';
import 'package:kure/services/cep_service.dart';
import 'package:kure/services/patient_service.dart';
import '../components/custom_text_input_field.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _cpfController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final TextEditingController _genderController = TextEditingController();
final TextEditingController _cepController = TextEditingController();
final TextEditingController _streetController = TextEditingController();
final TextEditingController _streetNumberController = TextEditingController();
final TextEditingController _complementController = TextEditingController();
final TextEditingController _neighborhoodController = TextEditingController();
final TextEditingController _cityController = TextEditingController();
final TextEditingController _stateController = TextEditingController();

final _cpfFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

final _cellPhoneFormater = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

final _cepFormatter = MaskTextInputFormatter(
  mask: '#####-###',
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
  String? cep,
      street,
      streetNumber,
      complement,
      neighborhood,
      addressComplement,
      city,
      state;
  bool _showGenderWarning = false;

  Future<void> savePatient(
    name,
    cpf,
    phone,
    birthday,
    gender,
    cep,
    street,
    streetNumber,
    complement,
    neighborhood,
    city,
    state,
  ) async {
    final PatientService patientService = PatientService.instance;

    await patientService.savePatient(
      name,
      cpf,
      phone,
      birthday,
      gender,
      cep,
      street,
      streetNumber,
      complement,
      neighborhood,
      city,
      state,
    );
  }

  Future<void> getAddress() async {
    final cep = _cepController.text;
      final address = await CepService.getAddressByCep(cep);
    if (address != null) {
      setState(() {
        _streetController.text = address['logradouro'] as String;
        _neighborhoodController.text = address['bairro'] as String;
        _cityController.text = address['localidade'] as String;
        _stateController.text = address['uf'] as String;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("CEP inválido ou não encontrado"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                      CustomTitle(title: "Cadastrar Paciente"),
                      SizedBox(height: 30),
                      CustomTextInputField(
                        hintText: "Nome completo",
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
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: CustomTextInputField(
                              hintText: "CPF",
                              controller: _cpfController,
                              validator: (value) {
                                if (!value!.isCPFValid) {
                                  return "CPF inválido";
                                }
                                return null;
                              },
                              inputFormatters: [_cpfFormatter],
                              onSaved:
                                  (value) => setState(() {
                                    cpf = value;
                                  }),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 5,
                            child: CustomDateInput(
                              controller: _birthdayController,
                              labelText: 'Nascimento',
                              validator: (value) {
                                if (!value!.isValidPatientName) {
                                  return "Data inválida";
                                }
                                return null;
                              },
                              onTap: selectDate,
                              onSaved: (value) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: CustomTextInputField(
                              hintText: "Telefone",
                              controller: _phoneController,
                              inputFormatters: [_cellPhoneFormater],
                              validator: (value) {
                                if (!value!.isValidPhone) {
                                  return "Telefone inválido";
                                }
                                return null;
                              },
                              onSaved:
                                  (value) => setState(() {
                                    phoneNumber = value;
                                  }),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 4,
                            child: CustomTextInputField(
                              hintText: "CEP",
                              controller: _cepController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.length != 9) {
                                  return "CEP inválido";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if(value.length == 9) {
                                  getAddress();
                                }

                              },
                              onSuffixTap: () => getAddress(),
                              onSaved:
                                  (value) => setState(() {
                                    if (value != null) {
                                      cep = value;
                                    }
                                  }),
                              inputFormatters: [_cepFormatter],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: CustomTextInputField(
                                hintText: "Rua",
                                controller: _streetController,
                                validator: (value) => null,
                                onSaved:
                                    (value) => setState(() {
                                      if (value != null) {
                                        street = value;
                                      }
                                    }),
                                inputFormatters: [],
                                readOnly: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: CustomTextInputField(
                              hintText: "n",
                              controller: _streetNumberController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "informe";
                                }
                                return null;
                              },
                              onSaved:
                                  (value) => setState(() {
                                    if (value != null) {
                                      streetNumber = value;
                                    }
                                  }),
                              inputFormatters: [],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: CustomTextInputField(
                              hintText: "Complemento",
                              controller: _complementController,
                              inputFormatters: [],
                              validator: (value) => null,
                              onSaved:
                                  (value) => setState(() {
                                    if (value != null) {
                                      complement = value;
                                    } else {
                                      complement = "";
                                    }
                                  }),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 4,
                            child: CustomTextInputField(
                              hintText: "Bairro",
                              controller: _neighborhoodController,
                              validator: (value) => null,
                              onSaved:
                                  (value) => setState(() {
                                    if (value != null) {
                                      neighborhood = value;
                                    }
                                  }),
                              inputFormatters: [],
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: CustomTextInputField(
                                hintText: "Cidade",
                                controller: _cityController,
                                validator: (value) => null,
                                onSaved:
                                    (value) => setState(() {
                                      if (value != null) {
                                        city = value;
                                      }
                                    }),
                                inputFormatters: [],
                                readOnly: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: CustomTextInputField(
                              hintText: "Estado",
                              controller: _stateController,
                              validator: (value) => null,
                              onSaved:
                                  (value) => setState(() {
                                    if (value != null) {
                                      state = value;
                                    }
                                  }),
                              inputFormatters: [],
                            ),
                          ),
                        ],
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
                                    fontSize: 11,
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
                            savePatient(
                                  name!,
                                  cpf!,
                                  phoneNumber!,
                                  birthday!,
                                  gender!,
                                  cep!,
                                  street!,
                                  streetNumber!,
                                  complement!,
                                  neighborhood!,
                                  city!,
                                  state!,
                                )
                                .then(
                                  (value) => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Paciente cadastrado com sucesso!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                )
                                .catchError(
                                  (error) => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
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
                            _stateController.clear();
                            _streetNumberController.clear();
                            _complementController.clear();
                            _cepController.clear();
                            _cityController.clear();
                            _stateController.clear();

                            setState(() {
                              name = null;
                              cpf = null;
                              phoneNumber = null;
                              gender = null;
                              birthday = null;
                              street = null;
                              streetNumber = null;
                              complement = null;
                              cep = null;
                              city = null;
                              state = null;
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
