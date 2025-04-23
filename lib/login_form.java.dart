import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/custom_form_input_container.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/extensions/extensions.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  String? email, password;

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
                  children: [
                    FadeInUp(
                      child: CustomFormTitle(title: "Login"),
                      duration: Duration(microseconds: 1500),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      child: CustomFormInputContainer(
                        inputFields: [
                          CustomTextInputField(
                            hintText: "E-mail",
                            controller: emailController,
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
                          CustomTextInputField(
                            hintText: "Digite a senha",
                            controller: passwordController,
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
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1700), 
                      child: Center(
                        child: TextButton(
                          onPressed: () {}, 
                          child: Text(
                            "Esqueceu a senha?", 
                            style: TextStyle(
                              color: Color.fromRGBO(196, 135, 198, 1)
                              ),
                            )
                          )
                        )
                      ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                          }
                          print("Login { ${email}, ${password} }");
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
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Criar Conta",
                            style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, .6),
                            ),
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
    );
  }
}
