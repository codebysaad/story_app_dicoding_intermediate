import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/preference_provider.dart';

import '../layouts/custom_pop_menu.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final preferenceProvider = context.read<PreferenceProvider>();
    preferenceProvider.getProfileName();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.profile,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  Widget _buildList() {
    return Consumer<PreferenceProvider>(builder: (context, provider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.profileName,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    const Text(
                      "Dicoding Accademy",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      "Belajar Pengembangan Aplikasi Flutter Intermediate",
                      style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
