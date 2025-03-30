import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  const TextInput(this.hintText, this.errorMessage, {super.key});
  
  final String hintText;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: hintText),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
        )
      ],
    );

  }
  
}
