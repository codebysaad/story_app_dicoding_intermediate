import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/data/models/stories_response.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:timeago/timeago.dart' as time_ago;

class StoryItem extends StatelessWidget {
  final ListStory story;

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
                child: Image.network(
                  story.photoUrl,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[400],
                        ),
                      );
                    }
                  },
                  errorBuilder: (_, __, ___) {
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
