import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  const CustomCheckBox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return  Checkbox(
      value: value,
      onChanged:(bool? value) => onChanged(value) ,
      activeColor: Color(0xFF15B86C),
    );
  }
}
