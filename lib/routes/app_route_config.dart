import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/pages/error_page.dart';
import 'package:story_app/pages/home3_page.dart';
import 'package:story_app/pages/home_page.dart';
import 'package:story_app/pages/login2_page.dart';
import 'package:story_app/pages/login3_page.dart';
import 'package:story_app/pages/login_page.dart';
import 'package:story_app/pages/register3_page.dart';
import 'package:story_app/pages/register_page.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';

import '../pages/splash_screen.dart';

class AppRouteConfig {
  GoRouter? router;

  GoRouter returnRouter(AuthProvider authProvider) {
    return router = GoRouter(
      routes: [
        // Routes configuration remains the same
        GoRoute(
          path: '/splash',
          name: AppRoutePaths.splashName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: AppRoutePaths.loginRouteName,
          builder: (context, state) => const Login3Page(),
          routes: [
            GoRoute(
              path: 'register',
              name: AppRoutePaths.registerRouteName,
              builder: (context, state) => const Register3Page(),
            )
          ],
        ),
        GoRoute(
            path: '/',
            name: AppRoutePaths.homeRouteName,
            builder: (context, state) => const Home3Page(),
            routes: [
              // GoRoute(
              //     path: 'detail/:id',
              //     name: 'detail',
              //     builder: (context, state) {
              //       String storyId =
              //           state.pathParameters['id'] ?? 'no id';
              //       return StoryDetailPage(storyId: storyId);
              //     }),
              // GoRoute(
              //   path: 'add',
              //   name: 'add',
              //   builder: (context, state) => const AddStoryPage(),
              // )
            ]),
      ],
      redirect: (context, state) {
        if (router == null) {
          return '/splash';
        } else {
          return null;
        }
      },
      errorPageBuilder: (context, state) {
        return const MaterialPage(child: ErrorPage());
      },
      initialLocation: authProvider.isLoggedIn ? '/' : '/login',
      debugLogDiagnostics: true,
      routerNeglect: true,
    );
  }

}