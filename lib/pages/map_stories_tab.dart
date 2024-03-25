import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/stories_provider.dart';

import '../layouts/loading_animation.dart';
import '../layouts/placemark_widget.dart';
import '../layouts/text_message.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class MapStoriesTab extends StatefulWidget {
  const MapStoriesTab({super.key});

  @override
  State<MapStoriesTab> createState() => _MapStoriesTabState();
}

class _MapStoriesTabState extends State<MapStoriesTab> {
  late LatLng initialLocation = const LatLng(-6.8215448,110.9348438);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;
  MapType selectedMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<StoriesProvider>(context, listen: false).getAllStoriesMap();
      final lat = context.read<StoriesProvider>().mapsResponse.listStory.first.lat;
      final lon = context.read<StoriesProvider>().mapsResponse.listStory.first.lon;
      initialLocation = LatLng(lat, lon);
    });
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<StoriesProvider>(builder: (key, storiesProvider, child) {
      final state = storiesProvider.state;
      return state.map(
          init: (_) {
            return const SizedBox();
          },
          loading: (_) {
            return LoadingAnimation(
              message: AppLocalizations.of(context)!.loading,
            );
          },
          hasData: (_) {
            return Center(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 7,
                      target: initialLocation,
                    ),
                    markers: markers,
                    mapType: selectedMapType,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: (controller) async {
                      for (var data in storiesProvider.mapsResponse.listStory) {
                        final info = await geo.placemarkFromCoordinates(
                            data.lat, data.lon);

                        final place = info[0];
                        final address =
                            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                        setState(() {
                          placemark = place;
                        });

                        final mark = LatLng(data.lat, data.lon);

                        final marker = Marker(
                          markerId: MarkerId(data.id),
                          position: mark,
                          onTap: () {
                            controller.animateCamera(
                              CameraUpdate.newLatLngZoom(mark, 10),
                            );
                            setState(() {
                              placemark = place;
                            });
                          },
                          infoWindow: InfoWindow(
                            title: data.name,
                            snippet: address,
                          ),
                        );
                        markers.add(marker);
                      }
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                  Positioned(
                    bottom: 75,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: "zoom-in",
                          onPressed: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                          child: const Icon(Icons.add),
                        ),
                        FloatingActionButton.small(
                          heroTag: "zoom-out",
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
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: null,
                      child: PopupMenuButton<MapType>(
                        onSelected: (MapType item) {
                          setState(() {
                            selectedMapType = item;
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
                  ),
                  Positioned(
                    top: 64,
                    right: 16,
                    child: FloatingActionButton.small(
                      child: const Icon(Icons.my_location),
                      onPressed: () => onMyLocationButtonPress(),
                    ),
                  ),
                  if (placemark == null)
                    const SizedBox()
                  else
                    Positioned(
                      bottom: 16,
                      right: 16,
                      left: 16,
                      child: PlacemarkWidget(
                        placemark: placemark!,
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
              onPressed: () => storiesProvider.getAllStories(),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Exit'),
                    content: const Text('Are You Sure to Leave?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.yes),
                        onPressed: () async {
                          exit(0);
                        },
                      ),
                    ],
                  ));
        }
      },
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        log("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
