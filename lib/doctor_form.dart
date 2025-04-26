import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'components/custom_form_input_container.dart';
import 'components/custom_form_title.dart';
import 'components/custom_text_input_field.dart';
import 'patient_form.dart';
import 'scheduled_appointments.dart';
import 'report_screen.dart';

class DoctorForm extends StatefulWidget {
  const DoctorForm({super.key});

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _crmController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isRailExtended = true;
  int selectedIndex = 1;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _crmFormatter = MaskTextInputFormatter(
    mask: '#####', // 5 dígitos para o CRM
    filter: {"#": RegExp(r'[0-9]')},
  );

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
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const CustomFormTitle(title: "Cadastro Médico"),
                        const SizedBox(height: 30),
                        CustomFormInputContainer(
                          inputFields: [
                            CustomTextInputField(
                              hintText: "Nome:",
                              controller: _nomeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Digite o nome do médico";
                                }
                                return null;
                              },
                              onSaved: (_) {},
                            ),
                            CustomTextInputField(
                              hintText: "Sobrenome:",
                              controller: _sobrenomeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Digite o sobrenome";
                                }
                                return null;
                              },
                              onSaved: (_) {},
                            ),
                            CustomTextInputField(
                              hintText: "CRM:",
                              controller: _crmController,
                              inputFormatters: [_crmFormatter],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Digite o número do CRM";
                                } else if (!RegExp(r"^[0-9]{5}$")
                                    .hasMatch(value)) {
                                  return "Digite um CRM válido de 5 números";
                                }
                                return null;
                              },
                              onSaved: (_) {},
                            ),
                            CustomTextInputField(
                              hintText: "Telefone:",
                              controller: _telefoneController,
                              inputFormatters: [_phoneFormatter],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Digite o telefone";
                                }
                                return null;
                              },
                              onSaved: (_) {},
                            ),
                            CustomTextInputField(
                              hintText: "Email:",
                              controller: _emailController,
                              inputFormatters: [],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Digite o email";
                                } else if (!RegExp(
                                        r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(value)) {
                                  return "Digite um email válido";
                                }
                                return null;
                              },
                              onSaved: (_) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Médico cadastrado com sucesso!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D72F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            "Salvar",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
