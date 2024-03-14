import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/layouts/icon_flag_locale.dart';
import 'package:story_app/pages/list_stories_tab.dart';
import 'package:story_app/pages/map_stories_tab.dart';

import '../layouts/custom_pop_menu.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late TabController _controller;

  int _bottomNavIndex = 0;
  static const String _stories = 'Stories';
  static const String _maps = 'Maps';

  final List<Widget> _listWidget = [
    const ListStoriesTab(),
    const MapStoriesTab(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news_solid : Icons.note_alt_rounded),
      label: _stories,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.map_fill : Icons.map_rounded),
      label: _maps,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Exit'),
                    content: const Text('Are You Sure to Leave?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.yes),
                        onPressed: () async {
                          exit(0);
                        },
                      ),
                    ],
                  ));
        }
      },
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItems),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.titleApp,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        IconFlagLocale(),
        CustomPopMenu(),
      ],
    );
  }
}
