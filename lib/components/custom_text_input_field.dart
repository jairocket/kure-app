import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    super.key,
    required this.hintText,
    required this.controller
  });

  final String hintText;
  final TextEditingController controller;

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
      child: TextFormField(     
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700
          )
        ),
        validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Preenchimento obrigatório";
            }
            return null;
          },
        controller: controller,
      ),
    );
  }
}
