import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/models/stories_response.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryItem extends StatelessWidget {
  final ListStory story;

  const StoryItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    const String fontFamily = 'CircularStd';
    String timeString = story.createdAt.toString();
    DateTime dateTime = DateTime.parse(timeString);
    DateTime now = DateTime.now();
    String timeAgo = timeago.format(now.subtract(now.difference(dateTime)));
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

// @override
// Widget build(BuildContext context) {
//   return GestureDetector(
//     key: const Key(''),
//     onTap: () {
//       if (context.mounted) {
//         context.goNamed(AppRoutePaths.detailRouteName,
//             pathParameters: {'id': story.id ?? ''});
//       }
//     },
//     child: Card(
//       elevation: 8,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: SizedBox(
//                 height: 100,
//                 width: 125,
//                 child: Image.network(
//                   story.photoUrl,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (_, child, loadingProgress) {
//                     if (loadingProgress == null) {
//                       return child;
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.grey[400],
//                         ),
//                       );
//                     }
//                   },
//                   errorBuilder: (_, __, ___) {
//                     return Icon(
//                       Icons.broken_image,
//                       size: 100,
//                       color: Colors.grey[400],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     story.name,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_pin,
//                         size: 18,
//                         color: Colors.red,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         story.name,
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyMedium!
//                             .copyWith(color: const Color(0xFF616161)),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.star,
//                               size: 18,
//                               color: Colors.amber,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               '${story.createdAt}',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(color: const Color(0xFF616161)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // isFavourite
//                       //     ? IconButton(
//                       //         onPressed: () {
//                       //           provider
//                       //               .deleteFavourite(story.id);
//                       //           ScaffoldMessenger.of(context)
//                       //               .showSnackBar(const SnackBar(
//                       //             duration: Duration(seconds: 1),
//                       //             content: Text(
//                       //               'Delete from Favourite',
//                       //             ),
//                       //           ));
//                       //         },
//                       //         color: Colors.blueAccent,
//                       //         icon: const Icon(Icons.bookmark_add))
//                       //     : IconButton(
//                       //         onPressed: () {
//                       //           provider
//                       //               .insertFavourite(story);
//                       //           ScaffoldMessenger.of(context)
//                       //               .showSnackBar(
//                       //             const SnackBar(
//                       //               duration: Duration(seconds: 1),
//                       //               content: Text(
//                       //                 'Insert to Favourite',
//                       //               ),
//                       //             ),
//                       //           );
//                       //         },
//                       //         color: Colors.blueAccent,
//                       //         icon: const Icon(
//                       //             Icons.bookmark_add_outlined),
//                       //       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
