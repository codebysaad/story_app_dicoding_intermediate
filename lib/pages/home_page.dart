import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/story_item.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/text_message.dart';
import '../utils/platform_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final loading = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Story App'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        // middle: Text('Story App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildList(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<StoriesProvider>(
        builder: (_, storiesProvider, __) {
          return Consumer<PreferenceProvider>(builder: (_, preference, __){
            return Column(
              children: [
                Text(preference.authToken, style: const TextStyle(fontSize: 12),),
                Text(storiesProvider.message, style: const TextStyle(fontSize: 12),),
              ],
            );
            // switch (storiesProvider.state) {
            //   case StateActivity.loading:
            //     return loading;
            //   case StateActivity.hasData:
            //     return ListView.builder(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 16,
            //         vertical: 8,
            //       ),
            //       // itemCount: storiesProvider.storiesResponse.listStory,
            //       itemBuilder: (_, index) {
            //         final stories = storiesProvider.storiesResponse.listStory[index];
            //         return StoryItem(story: stories);
            //       },
            //     );
            //   case StateActivity.noData:
            //     return const TextMessage(
            //       image: 'assets/images/empty-data.png',
            //       message: 'Empty Data',
            //     );
            //   case StateActivity.error:
            //     return TextMessage(
            //       image: 'assets/images/no-internet.png',
            //       message: 'Lost Connection',
            //       onPressed: () => storiesProvider.getAllStories(token: preference.authToken),
            //     );
            //   default:
            //     return const SizedBox();
            // }
          });
        },
      ),
    );
  }
}