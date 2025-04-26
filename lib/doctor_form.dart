import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'components/custom_form_input_container.dart';
import 'components/custom_form_title.dart';
import 'components/custom_text_input_field.dart';

class DoctorForm extends StatefulWidget {
  const DoctorForm({super.key});

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _crmController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

   final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _crmFormatter = MaskTextInputFormatter(
    mask: '#####', // 5 dígitos para o CRM
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
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
                        CustomForm(
                          formKey: _formKey,
                          customFormChildren: [
                            CustomFormTitle(title: "Crie sua conta"),
                            SizedBox(height: 30),
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
                            SizedBox(height: 15),
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
                            SizedBox(height: 15),
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
                            SizedBox(height: 15),
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
                            SizedBox(height: 15),
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