import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/preference/preferences_helper.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/pages/details_page.dart';
import 'package:story_app/pages/error_page.dart';
import 'package:story_app/pages/home3_page.dart';
import 'package:story_app/pages/login3_page.dart';
import 'package:story_app/pages/register3_page.dart';
import 'package:story_app/pages/splash_screen.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/routes/app_route_config.dart';
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
  late Future<SharedPreferences> sharedPref;
  GoRouter? router;

  @override
  void initState() {
    super.initState();
    final preferencesHelper = PreferencesHelper();
    final preferenceProvider = PreferenceProvider(preferencesHelper: preferencesHelper);
    final apiServices = ApiServices(http.Client());
    authProvider = AuthProvider(apiServices: apiServices, preferenceHelper: preferencesHelper);
    storiesProvider = StoriesProvider(apiServices: apiServices);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: storiesProvider),
        // ChangeNotifierProvider(
        //   create: (_) => StoriesProvider(
        //     apiServices: ApiServices(http.Client()),
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => RestaurantSearchProvider(
        //     apiService: ApiService(http.Client()),
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => SchedulingProvider(),
        // ),
        ChangeNotifierProvider(
          create: (context) => PreferenceProvider(
            preferencesHelper:
                PreferencesHelper(),
          ),
        )
      ],
      child: FutureBuilder<void>(
        future: authProvider.init(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            router = GoRouter(
              routes: [
                // Routes configuration remains the same
                GoRoute(
                  path: '/${AppRoutePaths.splashName}',
                  name: AppRoutePaths.splashName,
                  builder: (context, state) => const SplashScreen(),
                ),
                GoRoute(
                  path: '/${AppRoutePaths.loginRouteName}',
                  name: AppRoutePaths.loginRouteName,
                  builder: (context, state) => const Login3Page(),
                  routes: [
                    GoRoute(
                      path: AppRoutePaths.registerRouteName,
                      name: AppRoutePaths.registerRouteName,
                      builder: (context, state) => const Register3Page(),
                    )
                  ],
                ),
                GoRoute(
                    path: AppRoutePaths.rootRouteName,
                    name: AppRoutePaths.homeRouteName,
                    builder: (context, state) => const Home3Page(),
                    routes: [
                      GoRoute(
                          path: '${AppRoutePaths.detailRouteName}/:id',
                          name: AppRoutePaths.detailRouteName,
                          builder: (context, state) {
                            String storyId =
                                state.pathParameters['id'] ?? 'no id';
                            return DetailsPage(id: storyId);
                          }),
                      // GoRoute(
                      //   path: 'add',
                      //   name: 'add',
                      //   builder: (context, state) => const AddStoryPage(),
                      // )
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
              initialLocation: authProvider.isLoggedIn ? AppRoutePaths.rootRouteName : '/${AppRoutePaths.loginRouteName}',
              debugLogDiagnostics: true,
              routerNeglect: true,
            );
            return MaterialApp.router(
              theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
              routeInformationParser: router?.routeInformationParser,
              routerDelegate: router?.routerDelegate,
              routeInformationProvider: router?.routeInformationProvider,
              backButtonDispatcher: RootBackButtonDispatcher(),
              debugShowCheckedModeBanner: false,
            );
          } else {
            return const SplashScreen(); // Show a loading screen while initializing
          }
        },
      ),
    );
  }
}
