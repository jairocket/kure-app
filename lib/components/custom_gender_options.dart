import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';

enum GenderOptions { Masculino, Feminino, Outro }

class GenderButton extends StatelessWidget {
  const GenderButton({
    super.key, 
    required this.onChangedGenderButton, 
  });
  final Function(String?) onChangedGenderButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("Gênero"),
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomRadioButton(
                buttonLables: [...GenderOptions.values.map((value) => value.name)],
                buttonValues: [
                  ...GenderOptions.values.map((value) => value.name.toUpperCase()),
                ],
                radioButtonValue: (value) {
                  onChangedGenderButton(value.toString());
                },
                unSelectedColor: Color.fromARGB(255, 249, 248, 248),
                selectedColor: Color.fromRGBO(117, 107, 146, 1),
                wrapAlignment: WrapAlignment.spaceAround,
                spacing: 3.5,
                padding: 5.5,
                enableShape: true,
                autoWidth: true,
              ),
              
            ],
          ),
        ],       
      ),
    );
  }
}
