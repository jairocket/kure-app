import 'package:flutter/material.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/components/custom_title.dart';
import 'package:mobile/extensions/extensions.dart';
import 'package:mobile/services/doctor_service.dart';

String? email, password;

final TextEditingController emailController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final doctorService = DoctorService.instance;

      await doctorService.changePasswordByEmail(
        emailController.text.trim(),
        newPasswordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Senha atualizada com sucesso"),
          backgroundColor: Colors.green,
        ),
      );

      emailController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao atualizar a senha: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTitle(title: "Mudar senha"),

                  const SizedBox(height: 30),
                  CustomTextInputField(
                    hintText: "E-mail",
                    controller: emailController,
                    validator: (value) {
                      if (!value!.isValidEmail) {
                        return "Digite um email válido";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) email = value;
                    },
                    inputFormatters: [],
                  ),

                  const SizedBox(height: 16),
                  CustomTextInputField(
                    hintText: "Digite sua nova senha",
                    controller: newPasswordController,
                    validator: (value) {
                      if (value!.isValidPassword) {
                        return "Digite uma senha válida";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        password = value;
                      }
                    },
                    inputFormatters: [],
                    obscureText: _obscureNewPassword,
                    suffixIcon:
                        _obscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixTap: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  CustomTextInputField(
                    hintText: "Confirme sua nova senha",
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null ||
                          value != newPasswordController.text) {
                        return "As senhas não coincidem";
                      }
                      return null;
                    },
                    onSaved: (_) {},
                    inputFormatters: [],
                    obscureText: _obscureConfirmPassword,
                    suffixIcon:
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
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
                      "Salvar nova senha",
                      style: TextStyle(fontSize: 16, letterSpacing: 1.2),
                    ),
                  ),

                  SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    label: Text(
                      'Voltar',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
