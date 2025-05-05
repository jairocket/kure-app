import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    required this.onSaved,
    required this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final List<TextInputFormatter> inputFormatters;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final bool readOnly;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(12),   
      ),
      child: TextFormField(    
        obscureText: obscureText, 
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: onSuffixTap,
                )
              : null,
        ),
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        inputFormatters: [...inputFormatters],
        onChanged: onChanged,
      ),
    );
  }
}
