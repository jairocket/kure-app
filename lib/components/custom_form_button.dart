import 'package:flutter/material.dart';

class CustomFormButton extends StatelessWidget {
  const CustomFormButton({
    super.key,
    required this.buttonLabel
  });

  final String buttonLabel;

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      onPressed: () {
        print("pressed");

      },
      color: Color.fromRGBO(49, 39, 79, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
      height: 50,
      child: Center(
        child: Text(
          buttonLabel, 
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

