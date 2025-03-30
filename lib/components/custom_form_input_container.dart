import 'package:flutter/material.dart';

class CustomFormInputContainer extends StatelessWidget {
  const CustomFormInputContainer({
    super.key,
    required this.inputFields
  });

  final List<Widget> inputFields;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color.fromRGBO(196, 135, 198, 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(196, 135, 198, .3),
            blurRadius: 20,
            offset: Offset(0, 10)
          )
        ]
      ),
      child: Column(
        children: [
          ...inputFields,
        ],
      ),
    );
  }
}