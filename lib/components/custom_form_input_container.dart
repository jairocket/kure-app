import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({

    super.key,
    required this.formKey,
    required this.customFormChildren
  });

  final List<Widget> customFormChildren;
  final Key formKey; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ...customFormChildren,
          ],
        ),
      ),
    );
  }
}