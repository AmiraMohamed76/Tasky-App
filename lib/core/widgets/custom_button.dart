import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnTitle;
  final Function? onPressed;
  const CustomButton({super.key, required this.btnTitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: () => onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 40),
      ),
      child: Text(btnTitle),
    );
  }
}
