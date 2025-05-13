import 'package:flutter/material.dart';

class CustomDateInput extends StatelessWidget {
  const CustomDateInput({
    super.key,
    required this.controller,
    required this.validator,
    required this.onSaved,
    required this.labelText,
    required this.onTap,
  });
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        style: TextStyle(fontSize: 15),
        onTap: onTap,
        readOnly: true,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
