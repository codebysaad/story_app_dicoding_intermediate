import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/preference/preferences_helper.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/generated/l10n.dart';
import 'package:story_app/pages/add_new_story_page.dart';
import 'package:story_app/pages/details_page.dart';
import 'package:story_app/pages/error_page.dart';
import 'package:story_app/pages/home_page.dart';
import 'package:story_app/pages/login_page.dart';
import 'package:story_app/pages/profile_page.dart';
import 'package:story_app/pages/register_page.dart';
import 'package:story_app/pages/splash_screen.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/custom_image_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/routes/app_route_paths.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late AuthProvider authProvider;
  late StoriesProvider storiesProvider;
  late PreferencesHelper preferencesHelper;
  late PreferenceProvider preferenceProvider;
  late Future<SharedPreferences> sharedPref;
  GoRouter? router;

  @override
  void initState() {
    super.initState();
    final preferencesHelper = PreferencesHelper();
    preferenceProvider =
        PreferenceProvider(preferencesHelper: preferencesHelper);
    final apiServices = ApiServices(http.Client());
    authProvider = AuthProvider(
        apiServices: apiServices, preferenceHelper: preferencesHelper);
    storiesProvider = StoriesProvider(
        apiServices: apiServices, preferenceProvider: preferenceProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: storiesProvider),
        ChangeNotifierProvider.value(value: preferenceProvider),
        ChangeNotifierProvider.value(value: CustomImageProvider(),),
      ],
      child: FutureBuilder<void>(
        future: authProvider.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            router = GoRouter(
              routes: [
                GoRoute(
                  path: '/${AppRoutePaths.splashName}',
                  name: AppRoutePaths.splashName,
                  builder: (context, state) => const SplashScreen(),
                ),
                GoRoute(
                  path: '/${AppRoutePaths.loginRouteName}',
                  name: AppRoutePaths.loginRouteName,
                  builder: (context, state) => const LoginPage(),
                  routes: [
                    GoRoute(
                      path: AppRoutePaths.registerRouteName,
                      name: AppRoutePaths.registerRouteName,
                      builder: (context, state) => const RegisterPage(),
                    )
                  ],
                ),
                GoRoute(
                    path: AppRoutePaths.rootRouteName,
                    name: AppRoutePaths.homeRouteName,
                    builder: (context, state) => const HomePage(),
                    routes: [
                      GoRoute(
                          path: '${AppRoutePaths.detailRouteName}/:id/:title',
                          name: AppRoutePaths.detailRouteName,
                          builder: (context, state) {
                            String storyId =
                                state.pathParameters['id'] ?? 'no id';
                            String title =
                                state.pathParameters['title'] ?? 'no title';
                            return DetailsPage(
                              id: storyId,
                              title: title,
                            );
                          }),
                      GoRoute(
                        path: AppRoutePaths.addStoryRouteName,
                        name: AppRoutePaths.addStoryRouteName,
                        builder: (context, state) => const AddNewStoryPage(),
                      ),
                      GoRoute(
                        path: AppRoutePaths.profileRouteName,
                        name: AppRoutePaths.profileRouteName,
                        builder: (context, state) => const ProfilePage(),
                      ),
                    ]),
              ],
              redirect: (context, state) {
                if (router == null) {
                  return '/${AppRoutePaths.splashName}';
                } else {
                  return null;
                }
              },
              errorPageBuilder: (context, state) {
                return const MaterialPage(child: ErrorPage());
              },
              initialLocation: authProvider.isLoggedIn
                  ? AppRoutePaths.rootRouteName
                  : '/${AppRoutePaths.loginRouteName}',
              debugLogDiagnostics: true,
              routerNeglect: true,
            );
            log('Login Status Main: ${authProvider.isLoggedIn}');
            return MaterialApp.router(
              theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              routeInformationParser: router?.routeInformationParser,
              routerDelegate: router?.routerDelegate,
              routeInformationProvider: router?.routeInformationProvider,
              backButtonDispatcher: RootBackButtonDispatcher(),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizationDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('id', ''),
                Locale('en', ''),
              ],
            );
          } else {
            return const SplashScreen(); // Show a loading screen while initializing
          }
        },
      ),
    );
  }
}
