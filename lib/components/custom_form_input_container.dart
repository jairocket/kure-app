import 'package:flutter/material.dart';

class CustomFormInputContainer extends StatelessWidget {
  const CustomFormInputContainer({
    super.key,
    required this.inputFields,
  });

  final List<Widget> inputFields;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: inputFields
            .map((field) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: field,
                ))
            .toList(),
      ),
    );
  }
}
