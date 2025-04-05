import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    required this.onSaved

  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

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
        obscureText: obscureText, 
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700
          )
        ),
        validator: validator,
        onSaved: onSaved,
        controller: controller,
      ),
    );
  }
}
