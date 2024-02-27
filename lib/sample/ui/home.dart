import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/sample/routes/user_model.dart';

import '../routes/app_route_constants.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel = UserModel(id: 'Saad ID', username: 'Saad Fauzi');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Go Router Demo'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                context.go('/${MyAppRouteConstants.aboutRouteName}');
              },
              child: const Text('About Page')),
          ElevatedButton(
              onPressed: () {
                context.go('/${MyAppRouteConstants.profileRouteName}', extra: userModel);
              },
              child: const Text('Profile Page')),
          ElevatedButton(
              onPressed: () {
                context.go('/${MyAppRouteConstants.contactUsRouteName}');
              },
              child: const Text('ContactUs Page')),
        ],
      ),
    );
  }
}