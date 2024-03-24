import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storiesProvider = context.read<StoriesProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storiesProvider.pageItems != null) {
          storiesProvider.getAllStories();
        }
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   storiesProvider.getAllStories();
    // });
    Future.microtask(() async => storiesProvider.getAllStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final loading = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

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
          setState(() {
            context.read<StoriesProvider>().getAllStories();
          });
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
        final state = storiesProvider.state;
        switch(state){
          case StateActivity.init:
            return const SizedBox();
          case StateActivity.loading:
            return LoadingAnimation(
              message: AppLocalizations.of(context)!.loading,
            );
          case StateActivity.hasData:
            final stories = storiesProvider.listStories;
            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: stories.length + (storiesProvider.pageItems != null ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == stories.length && storiesProvider.pageItems != null) {
                  return loading;
                }
                // final stories = storiesProvider.storiesResponse.listStory[index];
                final story = stories[index];
                return StoryItem(story: story);
              },
            );
          case StateActivity.error:
            return TextMessage(
              image: 'assets/images/no-internet.png',
              message: AppLocalizations.of(context)?.lostConnection ??
                  'Lost Connection',
              titleButton: AppLocalizations.of(context)!.refresh,
              onPressed: () => storiesProvider.refreshStory(context),
            );
        }
      }
    });
  }
}