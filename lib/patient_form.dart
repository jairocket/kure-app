import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

import 'components/date_input.dart';
import 'components/custom_text_input_field.dart';
import 'components/custom_form_title.dart';
import 'components/custom_form_input_container.dart';
import 'address_form.dart';
import 'extensions/extensions.dart';
import 'services/database_service.dart';
import 'doctor_form.dart';
import 'scheduled_appointments.dart';
import 'report_screen.dart';

final nameController = TextEditingController();
final cpfController = TextEditingController();
final phoneController = TextEditingController();
final birthdayController = TextEditingController();

final _cpfFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

final _cellPhoneFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = DatabaseService.instance;

  String? name, cpf, phoneNumber, birthday;
  String? selectedGender;
  bool _showGenderWarning = false;
  int selectedIndex = 0;
  bool _isRailExtended = true;

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1914),
      lastDate: DateTime.now(),
    );

    initializeDateFormatting("pt_BR", null);

    if (picked != null) {
      setState(() {
        birthday = DateFormat.yMd("pt_BR").format(picked);
        birthdayController.text = birthday!;
      });
    }
  }

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const PatientForm()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const DoctorForm()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ScheduleAppointmentPage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ReportScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              extended: _isRailExtended,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    _isRailExtended = !_isRailExtended;
                  });
                },
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person_add),
                  label: Text("Cadastrar Paciente"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.medical_services),
                  label: Text("Cadastrar Médico"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_available),
                  label: Text("Marcar Consulta"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Relatório"),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomFormTitle(title: "Cadastro Novo Paciente"),
                      const SizedBox(height: 30),
                      CustomFormInputContainer(
                        inputFields: [
                          CustomTextInputField(
                            hintText: "Nome Completo:",
                            controller: nameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Digite seu nome completo";
                              } else if (!RegExp(r"^[a-zA-ZÀ-ÿ\s]+$")
                                  .hasMatch(value)) {
                                return "Apenas letras são permitidas";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                name =
                                    value[0].toUpperCase() + value.substring(1);
                              }
                            },
                          ),
                          CustomTextInputField(
                            hintText: "CPF:",
                            controller: cpfController,
                            inputFormatters: [_cpfFormatter],
                            validator: (value) => value!.isCPFValid
                                ? null
                                : "Digite um CPF válido.",
                            onSaved: (value) => cpf = value,
                          ),
                          CustomTextInputField(
                            hintText: "Telefone:",
                            controller: phoneController,
                            inputFormatters: [_cellPhoneFormatter],
                            validator: (value) => value!.isValidPhone
                                ? null
                                : "Digite um telefone válido.",
                            onSaved: (value) => phoneNumber = value,
                          ),
                          CustomDateInput(
                            controller: birthdayController,
                            labelText: "Data de Nascimento:",
                            onTap: selectDate,
                            validator: (value) => value == null || value.isEmpty
                                ? "Selecione uma data"
                                : null,
                            onSaved: (value) {},
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Gênero:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildRadioOption("Masculino"),
                              const SizedBox(width: 12),
                              _buildRadioOption("Feminino"),
                              const SizedBox(width: 12),
                              _buildRadioOption("Outro"),
                            ],
                          ),
                          if (_showGenderWarning)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Escolha uma opção",
                                  style: TextStyle(
                                      color: Colors.red.shade600, fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        onPressed: _submitForm,
                        color: const Color(0xFF2D72F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        height: 50,
                        minWidth: double.infinity,
                        child: const Text(
                          "Salvar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
              _showGenderWarning = false;
            });
          },
          activeColor: const Color(0xFF2D72F6),
        ),
        Text(label),
      ],
    );
  }

  void _submitForm() {
    if (selectedGender == null) {
      setState(() => _showGenderWarning = true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _databaseService.savePatient(
        name!,
        cpf!,
        phoneNumber!,
        birthday!,
        selectedGender!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddressForm()),
      );
    }
  }
}
