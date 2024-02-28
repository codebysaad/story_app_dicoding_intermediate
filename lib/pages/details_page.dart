import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../layouts/custom_pop_menu.dart';
import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';
import '../utils/state_activity.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  final String title;

  const DetailsPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  static const String fontFamily = 'CircularStd';

  @override
  void initState() {
    Future.microtask(() async {
      try {
        await context.read<StoriesProvider>().getDetailStory(id: widget.id);
      } on HttpException catch (e) {
        log('Detail Page: ${e.message}');
        debugPrint('$e - ${e.message}');
      } catch (e) {
        log('Detail Page: $e');
        debugPrint('$e');
      }
    });
    super.initState();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Details Story',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<StoriesProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case StateActivity.loading:
              return const LoadingAnimation(message: 'Loading...',);
            case StateActivity.hasData:
              String timeString =
                  provider.detailsStoryResponse.story.createdAt.toString();
              DateTime dateTime = DateTime.parse(timeString).toLocal();
              String dayStory = DateFormat('EEEE').format(dateTime);
              String monthStory = DateFormat('MMMM').format(dateTime);
              String hourStory = DateFormat('HH').format(dateTime);
              String minuteStory = DateFormat('mm').format(dateTime);
              String timeZone = dateTime.timeZoneName;
              String dateStory =
                  '$dayStory, ${dateTime.day} $monthStory ${dateTime.year}';
              String timeStory = '$hourStory : $minuteStory';
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        provider.detailsStoryResponse.story.photoUrl,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber,
                            backgroundImage: NetworkImage(
                              'https://ui-avatars.com/api/?name=${provider.detailsStoryResponse.story.name}',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              provider.detailsStoryResponse.story.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                dateStory,
                                style: const TextStyle(
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text(
                                '$timeStory $timeZone',
                                style: const TextStyle(
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
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
                            provider.detailsStoryResponse.story.description,
                            // style: body4.copyWith(
                            //   color: const Color(0xffBDBDBD),
                            // ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
                onPressed: () {
                  provider.getDetailStory(id: widget.id);
                  log('Id Story: ${widget.id}');
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
