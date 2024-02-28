import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/story_item.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/custom_pop_menu.dart';
import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';
import '../utils/item_pop_menu.dart';

class Home3Page extends StatefulWidget {
  const Home3Page({super.key});

  @override
  State<Home3Page> createState() => _Home3PageState();
}

class _Home3PageState extends State<Home3Page> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final authProvider = context.read<AuthProvider>();
    final storiesProvider = context.read<StoriesProvider>();

    log('Status Logout: ${authProvider.isLoggedIn}');

    Future.microtask(() async {
      try {
        await storiesProvider.getAllStories();
      } on HttpException catch (e) {
        debugPrint('$e - ${e.message}');
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Story App',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  Widget _buildList() {
    return Consumer<AuthProvider>(builder: (_, authProvider, __) {
      if (authProvider.isLoading) {
        return const LoadingAnimation(message: 'Logging Out...',);
      } else {
        return Consumer<StoriesProvider>(
          builder: (_, provider, __) {
            switch (provider.state) {
              case StateActivity.loading:
                return const LoadingAnimation(message: 'Loading...',);
              case StateActivity.hasData:
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: provider.storiesResponse.listStory.length,
                  // itemCount: 10,
                  itemBuilder: (_, index) {
                    final stories = provider.storiesResponse.listStory[index];
                    return StoryItem(story: stories);
                  },
                );
              case StateActivity.noData:
                return const TextMessage(
                  image: 'assets/images/empty-data.png',
                  message: 'Empty Data',
                );
              case StateActivity.error:
                return TextMessage(
                  image: 'assets/images/no-internet.png',
                  message: 'Lost Connection',
                  titleButton: 'Refresh',
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

  @override
  Widget build(BuildContext context) {
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
}
