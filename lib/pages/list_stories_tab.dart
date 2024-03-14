import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../layouts/loading_animation.dart';
import '../layouts/story_item.dart';
import '../layouts/text_message.dart';
import '../providers/auth_provider.dart';
import '../providers/stories_provider.dart';
import '../routes/app_route_paths.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';
import '../utils/state_activity.dart';

class ListStoriesTab extends StatefulWidget {
  const ListStoriesTab({super.key});

  @override
  State<ListStoriesTab> createState() => _ListStoriesTabState();
}

class _ListStoriesTabState extends State<ListStoriesTab> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoriesProvider>(context, listen: false).getAllStories();
    });
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_box, color: Colors.white),
        onPressed: () {
          context.goNamed(AppRoutePaths.addStoryRouteName);
        },
      ),
    );
  }

  Widget _buildList() {
    return Consumer2<AuthProvider, StoriesProvider>(builder: (context, authProvider, storiesProvider, child) {
      if (authProvider.isLoading) {
        return LoadingAnimation(
          message: AppLocalizations.of(context)?.loggingOut ?? 'Logging Out...',
        );
      } else {
        switch (storiesProvider.state) {
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
              itemCount: storiesProvider.storiesResponse.listStory.length,
              itemBuilder: (_, index) {
                final stories = storiesProvider.storiesResponse.listStory[index];
                return StoryItem(story: stories);
              },
            );
          case StateActivity.noData:
            return TextMessage(
              image: 'assets/images/empty-data.png',
              message:
              AppLocalizations.of(context)?.emptyData ?? 'Empty Data',
            );
          case StateActivity.error:
            return TextMessage(
              image: 'assets/images/no-internet.png',
              message: AppLocalizations.of(context)?.lostConnection ??
                  'Lost Connection',
              titleButton: AppLocalizations.of(context)!.refresh,
              onPressed: () => storiesProvider.getAllStories(),
            );
          default:
            return const SizedBox();
        }
      }
    });
  }
}