import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final String message;

  const LoadingAnimation({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/loading.json',
            width: 150,
            height: 150,
          ),
          Text(message, style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),)
        ],
      ),
    );
  }
}
