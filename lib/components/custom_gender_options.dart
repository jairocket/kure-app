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
    return CustomRadioButton(
      buttonLables: [
        for (var value in GenderOptions.values) value.name,
      ],
      buttonValues: [
        for (var value in GenderOptions.values) value.name.toUpperCase(),
      ],
      radioButtonValue: (value) {
        onChangedGenderButton(value.toString());
      },
      unSelectedColor: const Color(0xFFE0E0E0),
      selectedColor: const Color(0xFF756B92),
      enableShape: true,
      buttonTextStyle: const ButtonTextStyle(
        selectedColor: Colors.white,
        unSelectedColor: Colors.black87,
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      autoWidth: false,
      width: 100,
      elevation: 0,
      enableButtonWrap: true,
      spacing: 10,
      padding: 10,
    );
  }
}
