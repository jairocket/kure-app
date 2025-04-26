import 'package:flutter/material.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/doctor_form.dart';
import 'package:mobile/extensions/extensions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF2D72F6),
                  child: Text(
                    'K',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Kure App",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 40),
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
                        CustomTextInputField(
                          hintText: "E-mail",
                          controller: _emailController,
                          validator: (value) {
                            if (!value!.isValidEmail) {
                              return "Digite um email válido";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => {
                                if (value != null) {email = value},
                              },
                          inputFormatters: [],
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          hintText: "Digite a senha",
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Digite um email válido";
                            }
                            return null;
                          },
                          onSaved:
                              (value) => {
                                if (value != null) {password = value},
                              },
                          inputFormatters: [],
                          obscureText: _obscurePassword,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
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
                        SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: () {
                            this.dispose();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DoctorForm(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add, color: Colors.black87),
                          label: Text(
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
