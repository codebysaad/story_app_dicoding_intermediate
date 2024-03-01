import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color colorButton;
  final Icon icon;

  const CustomImageButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.colorButton,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        backgroundColor: colorButton,
      ),
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
