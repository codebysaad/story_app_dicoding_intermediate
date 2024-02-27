import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/sample/routes/user_model.dart';

import '../ui/about.dart';
import '../ui/contact_us.dart';
import '../ui/error_page.dart';
import '../ui/home.dart';
import '../ui/profile.dart';
import 'app_route_constants.dart';

class NyAppRouter {
  static GoRouter returnRouter() {
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: MyAppRouteConstants.homeRouteName,
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
          routes: <RouteBase>[
            GoRoute(
              path: MyAppRouteConstants.aboutRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const About();
              },
            ),
            GoRoute(
              path: MyAppRouteConstants.contactUsRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const ContactUS();
              },
            ),
            GoRoute(
              path: MyAppRouteConstants.profileRouteName,
              builder: (BuildContext context, GoRouterState state) {
                final user = state.extra as UserModel;
                return Profile(
                  userModel: user,
                );
              },
            ),
          ],
        ),
      ],
      errorPageBuilder: (context, state) {
        return const MaterialPage(child: ErrorPage());
      },
    );
    return router;
  }

// static GoRouter return2Router(bool isAuth) {
//   GoRouter router = GoRouter(
//     routes: [
//       GoRoute(
//         name: MyAppRouteConstants.profileRouteName,
//         path: '/profile/:username/:userid',
//         pageBuilder: (context, state) {
//           return MaterialPage(
//               child: Profile(
//                 userid: state.pathParameters['userid']!,
//                 username: state.pathParameters['username']!,
//               ));
//         },
//       ),
//     ],
//     errorPageBuilder: (context, state) {
//       return const MaterialPage(child: ErrorPage());
//     },
//     redirect: (context, state) {
//       if (!isAuth &&
//           state.matchedLocation
//               .startsWith('/${MyAppRouteConstants.profileRouteName}')) {
//         return context.namedLocation(MyAppRouteConstants.contactUsRouteName);
//       } else {
//         return null;
//       }
//     },
//   );
//   return router;
// }
}
