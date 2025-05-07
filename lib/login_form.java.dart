import 'package:flutter/material.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/doctor_form.dart';
import 'package:mobile/extensions/extensions.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF2D72F6),
                    child: const Text(
                      'K',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Kure App",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: const [
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
                        CustomTextInputField(
                          hintText: "E-mail",
                          controller: _emailController,
                          validator: (value) {
                            if (!value!.isValidEmail) {
                              return "Digite um email válido";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              email = value;
                            }
                          },
                          inputFormatters: [],
                        ),
                        const SizedBox(height: 16),
                        CustomTextInputField(
                          hintText: "Digite sua senha",
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.length < 8) {
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
                          obscureText: _obscurePassword,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                appState.setLoggedUser(email!, password!).then(
                                      (value) => ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Login efetuado com sucesso!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ).catchError(
                                      (error) => ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            error.toString(),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    );
                                _formkey.currentState!.reset();
                                _emailController.clear();
                                _passwordController.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D72F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DoctorForm(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.black87),
                          label: const Text(
                            'Criar Nova conta',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
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
      ),
    );
  }
}
