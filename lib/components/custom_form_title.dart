import 'package:flutter/material.dart';

class CustomFormTitle extends StatelessWidget {
  const CustomFormTitle({
    super.key,
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Color.fromRGBO(49, 39, 79, 1),
        fontWeight: FontWeight.bold, 
        fontSize: 30
      )
    );
  }
}