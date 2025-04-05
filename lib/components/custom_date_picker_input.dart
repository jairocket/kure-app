import 'package:flutter/material.dart';

class CustomDatePickerInput extends StatelessWidget {
  const CustomDatePickerInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(196, 135, 198, .3)
          )
        )
      ),
      child: InputDatePickerFormField(
        key: Key("birthday"),
        firstDate: DateTime(1910), 
        lastDate: DateTime(DateTime.now().year),
        fieldLabelText: "Digite a data de nascimento",
        onDateSubmitted: (value) {},
      ),
    );
  }
}
