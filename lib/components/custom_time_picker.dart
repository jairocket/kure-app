import 'package:flutter/material.dart';

class CustomTimeInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTimeInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.onTap,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: Icon(
                Icons.access_time,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            validator: validator,
            onSaved: onSaved,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
