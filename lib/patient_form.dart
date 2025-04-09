import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/components/date_input.dart';
import 'package:mobile/extensions/extensions.dart';
import 'components/custom_text_input_field.dart';
import 'components/custom_form_title.dart';
import 'components/custom_form_input_container.dart';
import 'components/drop_down_input.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController cpfController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController birthdayController = TextEditingController();
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _cellPhoneFormater = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  State<StatefulWidget> createState() => _PatientFormState();
}

const List<String> genderOptions = <String>['F', 'M'];
String? firstName, lastName, cpf, phoneNumber;
String gender = genderOptions.first;
DateTime? birthday;

class Patient {
  final String name;
  final String cpf;

  Patient(this.name, this.cpf);
}

class _PatientFormState extends State<PatientForm> {
  
Future<void> selectDate() async {
  DateTime? _picked = await showDatePicker(
    context: context, 
    firstDate: DateTime(1914), 
    lastDate: DateTime.now()
  );

  initializeDateFormatting("pt_BR", null);

  if(_picked != null) {
    print(DateFormat.yMd("pt_BR").format(_picked));
    setState(() {
      birthday = _picked;
      birthdayController.text = DateFormat.yMd("pt_BR").format(_picked);
    });
  }
}

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: Duration(microseconds: 1500),
                      child: CustomFormTitle(title: "Cadastrar novo Paciente"),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: CustomFormInputContainer(
                        inputFields: [
                          CustomTextInputField(
                            hintText: "Digite o nome",
                            controller: firstNameController,
                            inputFormatters: [],
                            validator: (value) {
                              if (!value!.isValidPatientName) {
                                return "Digite um nome válido";
                              }
                              return null;
                            },
                            onSaved:
                                (value) => setState(() {
                                  firstName = value;
                                }),
                          ),
                          CustomTextInputField(
                            hintText: "Digite o sobrenome",
                            controller: lastNameController,
                            inputFormatters: [],
                            validator: (value) {
                              if (!value!.isValidPatientName) {
                                return "Digite um sobrenome válido";
                              }
                              return null;
                            },
                            onSaved:
                                (value) => setState(() {
                                  lastName = value;
                                }),
                          ),
                          CustomTextInputField(
                            hintText: "Digite o CPF",
                            controller: cpfController,

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
                          CustomTextInputField(
                            hintText: "Digite o telefone",
                            controller: phoneController,
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
                          CustomDateInput(
                            controller: birthdayController,
                            labelText: 'Data de nascimento',
                            validator: (value) {
                              if (!value!.isValidPatientName) {
                                return "Digite data válida";
                              }
                              return null;
                            },
                            onTap: selectDate,
                            onSaved:
                                (value) => setState(() {}),
                          ),
                          CustomDropDownButton(
                            value: gender,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            print(
                              "Patient ${firstName} ${lastName}, ${phoneNumber}, ${cpf}, ${gender} ${birthday}",
                            );
                          }
                        },
                        color: Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
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
