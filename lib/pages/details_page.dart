import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/models/details_story_response.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/preference_provider.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  const DetailsPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late DetailsStoryResponse detailsStoryResponse;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final preferenceProvider = context.read<PreferenceProvider>();
    final token = preferenceProvider.authToken;
    final data =
        context.read<StoriesProvider>().getDetailStory(token: token, id: widget.id);
    detailsStoryResponse = await data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<StoriesProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              String timeString = detailsStoryResponse.story!.createdAt.toString();
              DateTime dateTime = DateTime.parse(timeString);
              DateTime now = DateTime.now();
              String timeAgo =
                  timeago.format(now.subtract(now.difference(dateTime)));
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: SvgPicture.asset(
                        //     Assets.icon.arrowLeft1,
                        //     height: 24,
                        //     width: 24,
                        //     fit: BoxFit.scaleDown,
                        //   ),
                        // ),
                        const Spacer(),
                        // SvgPicture.asset(
                        //   Assets.icon.heart1,
                        //   height: 24,
                        //   width: 24,
                        //   fit: BoxFit.scaleDown,
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        // SvgPicture.asset(
                        //   Assets.icon.plusCircle1,
                        //   height: 24,
                        //   width: 24,
                        //   fit: BoxFit.scaleDown,
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        // SvgPicture.asset(
                        //   Assets.icon.upload,
                        //   height: 24,
                        //   width: 24,
                        //   fit: BoxFit.scaleDown,
                        // ),
                      ],
                    ),
                  ),
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
                                'https://ui-avatars.com/api/?name=${detailsStoryResponse.story.name}',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                detailsStoryResponse.story.name,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              timeAgo,
                              // style: body4.copyWith(
                              //   color: const Color(0xffBDBDBD),
                              // ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Image.network(
                    detailsStoryResponse.story.photoUrl,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              '125',
                              // style: body4.copyWith(
                              //   color: const Color(0xffBDBDBD),
                              // ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            // SvgPicture.asset(
                            //   Assets.icon.eye,
                            //   height: 20,
                            //   width: 20,
                            //   fit: BoxFit.scaleDown,
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '125',
                              // style: body4.copyWith(
                              //   color: const Color(0xffBDBDBD),
                              // ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            // SvgPicture.asset(
                            //   Assets.icon.chatFill,
                            //   height: 20,
                            //   width: 20,
                            //   fit: BoxFit.scaleDown,
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '125',
                              // style: body4.copyWith(
                              //   color: const Color(0xffBDBDBD),
                              // ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            // SvgPicture.asset(
                            //   Assets.icon.heartFill,
                            //   height: 20,
                            //   width: 20,
                            //   fit: BoxFit.scaleDown,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                      top: 10.25,
                      bottom: 16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          // style: title1,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          detailsStoryResponse.story!.description!,
                          // style: body4.copyWith(
                          //   color: const Color(0xffBDBDBD),
                          // ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
