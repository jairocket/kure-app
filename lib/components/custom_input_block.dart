import 'package:flutter/material.dart';

class CustomInputBlock extends StatelessWidget {
  const CustomInputBlock({
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
