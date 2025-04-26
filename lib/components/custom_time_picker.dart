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
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: const Icon(
                Icons.access_time,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
