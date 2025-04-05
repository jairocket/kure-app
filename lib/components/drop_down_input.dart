import 'package:flutter/material.dart';

const List<String> list = <String>['M', 'F', 'N'];

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.onChanged,
    required this.value,
  });
  final Function(String?) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Gênero"),
        SizedBox(width: 30),
        DropdownButton<String>(
          padding: EdgeInsets.all(10),
          value: value,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(height: 2, color: Colors.deepPurpleAccent),
          onChanged: onChanged,
          items:
              list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ],
    );
  }
}
