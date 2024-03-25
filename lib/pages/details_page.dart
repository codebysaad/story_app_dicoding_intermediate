import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/stories_provider.dart';

import '../layouts/custom_pop_menu.dart';
import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

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
    super.initState();
    Future.microtask(
        () => context.read<StoriesProvider>().getDetailStory(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.detailStory,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  Widget _buildList() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<StoriesProvider>(
            builder: (context, provider, child) {
              final state = provider.state;
              return state.map(
                  init: (_) {
                    return const SizedBox();
                  },
                  loading: (_) {
                    return LoadingAnimation(
                      message:
                      AppLocalizations.of(context)?.loading ?? 'Loading...',
                    );
                  },
                  hasData: (_) {
                    String timeString =
                    provider.detailsStoryResponse.story.createdAt.toString();
                    String locale = Localizations.localeOf(context).languageCode;
                    DateTime dateTime = DateTime.parse(timeString).toLocal();
                    String dayStory = DateFormat.EEEE(locale).format(dateTime);
                    String monthStory = DateFormat.MMMM(locale).format(dateTime);
                    String hourStory = DateFormat('HH').format(dateTime);
                    String minuteStory = DateFormat('mm').format(dateTime);
                    String timeZone = dateTime.timeZoneName;
                    String dateStory =
                        '$dayStory, ${dateTime.day} $monthStory ${dateTime.year}';
                    String timeStory = '$hourStory:$minuteStory';
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                Text(
                                  AppLocalizations.of(context)?.description ??
                                      'Description',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  provider.detailsStoryResponse.story.description,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (provider.detailsStoryResponse.story.lat != null && provider.detailsStoryResponse.story.lon != null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blueAccent.withOpacity(.6),
                                  width: 2,
                                ),
                              ),
                              height: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(provider.detailsStoryResponse.story.lat!, provider.detailsStoryResponse.story.lon!),
                                    zoom: 15,
                                  ),
                                  onMapCreated: (controller) {
                                    provider.defineMarker(LatLng(provider.detailsStoryResponse.story.lat!, provider.detailsStoryResponse.story.lon!));
                                  },
                                  markers: provider.markers,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  error: (_) {
                    return TextMessage(
                      image: 'assets/images/no-internet.png',
                      message: AppLocalizations.of(context)?.lostConnection ??
                          'Lost Connection',
                      titleButton: AppLocalizations.of(context)!.refresh,
                      onPressed: () {
                        provider.getDetailStory(id: widget.id);
                        log('Id Story: ${widget.id}');
                      },
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
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
}
