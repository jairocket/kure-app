import 'package:flutter/material.dart';

class CustomDateInput extends StatelessWidget {
  const CustomDateInput({
    super.key,
    required this.controller,
    required this.validator,
    required this.onSaved,
    required this.labelText,
    required this.onTap
  });
    final String labelText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
        ),
        onTap: onTap,
        readOnly: true,
        onSaved: onSaved,
      ),
    );
  }


}
