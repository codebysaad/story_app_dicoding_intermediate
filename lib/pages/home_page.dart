import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/icon_flag_locale.dart';
import 'package:story_app/layouts/story_item.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/custom_pop_menu.dart';
import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final storiesProvider = context.read<StoriesProvider>();
    Future.microtask(() async => await storiesProvider.getAllStories());
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
                          Navigator.of(context).pop();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_box, color: Colors.white),
        onPressed: () {
          context.goNamed(AppRoutePaths.addStoryRouteName);
        },
      ),
      key: const Key(''),
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

  Widget _buildList() {
    return Consumer<AuthProvider>(builder: (_, authProvider, __) {
      if (authProvider.isLoading) {
        return LoadingAnimation(
          message: AppLocalizations.of(context)?.loggingOut ?? 'Logging Out...',
        );
      } else {
        return Consumer<StoriesProvider>(
          builder: (_, provider, __) {
            switch (provider.state) {
              case StateActivity.loading:
                return LoadingAnimation(
                  message: AppLocalizations.of(context)!.loading,
                );
              case StateActivity.hasData:
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: provider.storiesResponse.listStory.length,
                  itemBuilder: (_, index) {
                    final stories = provider.storiesResponse.listStory[index];
                    return StoryItem(story: stories);
                  },
                );
              case StateActivity.noData:
                return TextMessage(
                  image: 'assets/images/empty-data.png',
                  message: AppLocalizations.of(context)?.emptyData ?? 'Empty Data',
                );
              case StateActivity.error:
                return TextMessage(
                  image: 'assets/images/no-internet.png',
                  message: AppLocalizations.of(context)?.lostConnection ?? 'Lost Connection',
                  titleButton: AppLocalizations.of(context)!.refresh,
                  onPressed: () => provider.getAllStories(),
                );
              default:
                return const SizedBox();
            }
          },
        );
      }
    });
  }
}
