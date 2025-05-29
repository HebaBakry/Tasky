import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.text,
    this.hintText,
    this.validator,
    required this.controller,
    this.maxLines = 1,
  });
  final String text;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 16),
        ),
        SizedBox(height: 8),
        TextFormField(
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(hintText: hintText),
          validator: validator,
          controller: controller,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
