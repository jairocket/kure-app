import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';

enum GenderOptions { Masculino, Feminino, Outro }

class GenderButton extends StatelessWidget {
  const GenderButton({super.key, required this.onChangedGenderButton});
  final Function(String?) onChangedGenderButton;

  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      buttonLables: [...GenderOptions.values.map((value) => value.name)],
      buttonValues: [
        ...GenderOptions.values.map((value) => value.name.toUpperCase()),
      ],
      radioButtonValue: (value) {
        onChangedGenderButton(value.toString());
      },
      unSelectedColor: Color(0xFFE0E0E0),
      selectedColor: Color(0xFF756B92),
      spacing: 1,
      padding: 1,
      elevation: 0,
      enableShape: true,
      autoWidth: false,
      width: 83,
      enableButtonWrap: true,
      buttonTextStyle: ButtonTextStyle(
        selectedColor: Colors.white,
        unSelectedColor: Colors.black87,
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
