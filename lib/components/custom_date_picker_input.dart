import 'package:flutter/material.dart';

class CustomDatePickerInput extends StatelessWidget {
  const CustomDatePickerInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InputDatePickerFormField(
      key: Key("birthday"),
      firstDate: DateTime(1910), 
      lastDate: DateTime(DateTime.now().year),
      fieldLabelText: "Digite a data de nascimento",
      onDateSubmitted: (value) {},
    );
  }
}
