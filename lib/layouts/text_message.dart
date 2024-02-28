import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final String image;
  final String message;
  final String? titleButton;
  final Function()? onPressed;

  const TextMessage({
    super.key,
    required this.image,
    required this.message,
    this.titleButton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (onPressed != null && titleButton != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: onPressed,
              child: Text(
                titleButton!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
