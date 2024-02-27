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

import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';

class Home3Page extends StatefulWidget {

  const Home3Page({super.key});

  @override
  State<Home3Page> createState() => _Home3PageState();
}

class _Home3PageState extends State<Home3Page>{
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final preferenceProvider = context.read<PreferenceProvider>();
    final storiesProvider = context.read<StoriesProvider>();

    Future.microtask(() async {
      final token = preferenceProvider.authToken;

      // scrollController.addListener(() {
      //   if (scrollController.position.pixels >=
      //       scrollController.position.maxScrollExtent) {
      //     if (!storiesProvider.isLoading && storiesProvider.hasMorePages) {
      //       storiesProvider.getAllStories(page: storiesProvider.pageItems, token: token);
      //     }
      //   }
      // });
      try {
        await storiesProvider
            .getAllStories(token: token);

      } on HttpException catch (e) {
        debugPrint('$e - ${e.message}');
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Story App',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: [
        Consumer<AuthProvider>(builder: (context, authProvider, child){
          return PopupMenuButton(
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Profile"),
                  ),

                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),

                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value) async {
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  print("Settings menu is selected.");
                }else if(value == 2){
                  final result = await authProvider.logout();
                  if (context.mounted && result) {
                    context.goNamed(AppRoutePaths.loginRouteName);
                  }
                  print("Logout menu is selected.");
                }
              }
          );
        }),
      ],
    );
  }

  Widget _buildList() {
    return Consumer<PreferenceProvider>(builder: (_, preference, __){
      return Consumer<StoriesProvider>(
        builder: (_, provider, __) {
          switch (provider.state) {
            case StateActivity.loading:
              return const LoadingAnimation();
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
                onPressed: () => provider.getAllStories(token: preference.authToken),
              );
            default:
              return const SizedBox();
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
      key: const Key(''),
    );
  }
}