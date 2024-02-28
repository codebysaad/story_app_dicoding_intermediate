import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/routes/app_route_paths.dart';

import '../layouts/text_message.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar(),
      body: Center(
        child: TextMessage(
          image: 'assets/images/no-internet.png',
          message: 'Lost Connection',
          titleButton: 'Back',
          onPressed: () {
            context.goNamed(AppRoutePaths.rootRouteName);
          },
        ),
      ),
    );
  }
}