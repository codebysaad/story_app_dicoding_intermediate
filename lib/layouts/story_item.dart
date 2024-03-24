import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/data/models/data_stories.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:timeago/timeago.dart' as time_ago;

class StoryItem extends StatelessWidget {
  final DataStories story;

  const StoryItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    const String fontFamily = 'CircularStd';
    String timeString = story.createdAt.toString();
    DateTime dateTime = DateTime.parse(timeString);
    DateTime now = DateTime.now();
    String timeAgo = time_ago.format(now.subtract(now.difference(dateTime)));
    return GestureDetector(
      onTap: () {
        if (context.mounted) {
          context.goNamed(AppRoutePaths.detailRouteName,
              pathParameters: {'id': story.id, 'title': story.name});
        }
      },
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?name=${story.name}',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            story.name,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffBDBDBD),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: story.photoUrl,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  errorWidget: (context, url, error) {
                    return Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey[400],
                    );
                  },
                  placeholder: (context, url) {
                    return Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
