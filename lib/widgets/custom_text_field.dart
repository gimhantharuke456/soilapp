// lib/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

// lib/widgets/custom_filled_button.dart
