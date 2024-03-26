import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/loading_animation.dart';
import '../providers/location_provider.dart';
import '../layouts/placemark_widget.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMapsPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.getLocation,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
    );
  }

  Widget _buildList() {
    return Scaffold(
      body: SafeArea(
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.initLocation,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                    locationProvider.getMyLocation(context, mapController);
                  },
                  markers: locationProvider.markers,
                  mapType: locationProvider.selectedMapType,
                  zoomControlsEnabled: false,
                  onTap: (argument) => locationProvider.onTapMap(
                      context, mapController, argument),
                ),
                if (locationProvider.placemark != null)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Consumer<StoriesProvider>(
                          builder: (context, storiesProv, _) {
                            return FloatingActionButton.small(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                onPressed: () {
                                  storiesProv.addLocation(context);
                                  context.pop();
                                  log(storiesProv.lat.toString());
                                  log(storiesProv.lon.toString());
                                },
                                child: const Icon(Icons.add_location_alt_outlined),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        PlacemarkWidget(
                          placemark: locationProvider.placemark!,
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: null,
                            child: PopupMenuButton<MapType>(
                              onSelected: (MapType item) {
                                setState(() {
                                  locationProvider.selectedMapType = item;
                                });
                              },
                              offset: const Offset(0, 54),
                              icon: const Icon(Icons.layers_outlined),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<MapType>>[
                                const PopupMenuItem<MapType>(
                                  value: MapType.normal,
                                  child: Text('Normal'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.satellite,
                                  child: Text('Satellite'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.terrain,
                                  child: Text('Terrain'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.hybrid,
                                  child: Text('Hybrid'),
                                ),
                              ],
                            ),
                          ),
                          FloatingActionButton.small(
                            heroTag: 'your-location',
                            onPressed: () {
                              locationProvider.getMyLocation(
                                  context, mapController);
                            },
                            child: const Icon(Icons.my_location),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom-in',
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                      FloatingActionButton.small(
                        heroTag: 'zoom-out',
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
                if (locationProvider.state == const StateActivity.loading())
                  LoadingAnimation(
                    message:
                        AppLocalizations.of(context)?.loading ?? 'Loading...',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
