import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLines;

  final String hintText;
  final Function(String?)? validator;
  final String title;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.validator,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          validator: validator != null ? (String? value) => validator!(value) : null,
          decoration: InputDecoration(hintText: hintText),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
