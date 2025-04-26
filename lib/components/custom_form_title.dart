import 'package:flutter/material.dart';

class CustomFormTitle extends StatelessWidget {
  const CustomFormTitle({
    super.key,
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold, 
          fontSize: 26,
          letterSpacing: 1.2
        )
      ),
    );
  }
}