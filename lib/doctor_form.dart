import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/extensions/extensions.dart';
import 'package:mobile/services/doctor_service.dart';
import 'components/custom_form_title.dart';
import 'components/custom_text_input_field.dart';

class DoctorForm extends StatefulWidget {
  const DoctorForm({super.key});

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? name, crm, phone, email, password, repeatedPassword;

  final _nameController = TextEditingController();
  final _crmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  bool _obscureText = true;
  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _crmFormatter = MaskTextInputFormatter(
    mask: '#####', // 5 dígitos para o CRM
    filter: {"#": RegExp(r'[0-9]')},
  );

  void _cleanInputData() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _crmController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
    _repeatedPasswordController.clear();

    setState(() {
      name = null;
      crm = null;
      phone = null;
      email = null;
      password = null;
      repeatedPassword = null;
    });
  }

  Future<void> saveDoctor(name, crm, phone, email, password) async {
    final DoctorService doctorService = DoctorService.instance;
    await doctorService.saveDoctor(name, crm, phone, email, password);
  }

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
                        CustomFormTitle(title: "Crie sua conta"),
                        SizedBox(height: 30),
                        CustomTextInputField(
                          hintText: "Nome:",
                          controller: _nameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-ZÀ-ÿ\s]"),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Digite o nome completo";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                name = value;
                              }),
                        ),
                        SizedBox(height: 15),
                        CustomTextInputField(
                          hintText: "CRM:",
                          controller: _crmController,
                          inputFormatters: [_crmFormatter],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Digite o número do CRM";
                            } else if (!RegExp(r"^[0-9]{5}$").hasMatch(value)) {
                              return "Digite um CRM válido de 5 números";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                crm = value;
                              }),
                        ),
                        SizedBox(height: 15),
                        CustomTextInputField(
                          hintText: "Telefone:",
                          controller: _phoneController,
                          inputFormatters: [_phoneFormatter],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Digite o telefone";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                phone = value;
                              }),
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
                              r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                            ).hasMatch(value)) {
                              return "Digite um email válido";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                email = value;
                              }),
                        ),
                        SizedBox(height: 15),
                        CustomTextInputField(
                          hintText: "Digite uma nova senha",
                          controller: _passwordController,
                          validator: (value) {
                            if (!value!.isValidPassword) {
                              return "Digite uma senha válida";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                password = value;
                              }),
                          inputFormatters: [],
                          obscureText: _obscureText,
                        ),
                        SizedBox(height: 15),
                        CustomTextInputField(
                          hintText: "Confirme a senha",
                          controller: _repeatedPasswordController,
                          validator: (value) {
                            if (value! != _passwordController.text) {
                              return "Senha digitada não confere";
                            }
                            if (value!.trim().length == 0) {
                              return "Confirme a senha";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => setState(() {
                                repeatedPassword = value;
                              }),
                          inputFormatters: [],
                          obscureText: _obscureText,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              saveDoctor(name, crm, phone, email, password)
                                  .then(
                                    (value) => ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Médico cadastrado com sucesso!",
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
                                        content: Text('Médico já cadastrado.'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    ),
                                  );
                              _cleanInputData();
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
                          child: const Text(
                            "Salvar",
                            style: TextStyle(fontSize: 16, letterSpacing: 1.2),
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
