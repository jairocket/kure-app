
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'components/custom_text_input_field.dart';
import 'components/custom_form_button.dart';
import 'components/custom_form_title.dart';
import 'components/custom_form_input_container.dart';
import 'components/custom_input_block.dart';
import 'components/drop_down_input.dart';


  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();

class PatientForm extends StatefulWidget{
  const PatientForm({super.key});
  
  @override
  State<StatefulWidget> createState() => _PatientFormState(); 
}

class Patient {
  final String name;
  final String cpf;

  Patient(
    this.name,
    this.cpf,
  );


}

class FormState extends ChangeNotifier {
  onPressed() {
    print("presssed");
  }
  


}

class _PatientFormState extends State<PatientForm> {

  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeInUp(
                      duration: Duration(seconds: 1),
                      child: Container(
                        // inserir imagem
                      )
                    )
                  ),
                ],
              ),
            ),
            Form(
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
                            controller: nameController
                          ),
                          CustomTextInputField(
                            hintText: "Digite o CPF",
                            controller: cpfController,
                          ),
                          CustomInputBlock(),
                          CustomDropDownButton()
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(
                        milliseconds: 1900
                      ),
                      child: CustomFormButton(buttonLabel: "Salvar")
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



