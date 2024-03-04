import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.hint,
    this.controller,
    this.isVisible = true,
    this.onIconPressed,
    this.onChanged,
    this.validator
  });

  final TextEditingController? controller;
  final bool isVisible;
  final String? hint;
  final VoidCallback? onIconPressed;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        fillColor: Colors.blueAccent.withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            (isVisible) ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
