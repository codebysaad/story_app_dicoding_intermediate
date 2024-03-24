import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_image_button.dart';
import 'package:story_app/providers/location_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:story_app/utils/state_activity.dart';
import '../layouts/custom_pop_menu.dart';
import '../layouts/placemark_widget.dart';
import '../utils/common.dart';
import '../utils/location_handler.dart';
import '../utils/platform_widget.dart';

class AddNewStoryPage extends StatefulWidget {
  const AddNewStoryPage({super.key});

  @override
  _AddNewStoryPageState createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final LocationHandler _locationHandler = LocationHandler();

  LatLng inputLang = const LatLng(0.0, 0.0);
  geo.Placemark? placemark;
  bool isLoadingLocation = false;
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  final loading = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildList() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width * 0.9,
            margin: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Consumer2<StoriesProvider, LocationProvider>(
                  builder: (context, storiesProvider, locationProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImagePreview(),
                    _buildImageButtons(),
                    _buildDescriptionTextField(),
                    _buildGetLocationButton(storiesProvider, locationProvider),
                    const SizedBox(height: 12),
                    Consumer<StoriesProvider>(
                        builder: (context, storiesProvider, child) {
                      return storiesProvider.isLoading
                          ? loading
                          : Container(
                              padding: const EdgeInsets.only(top: 3, left: 3),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _onUpload();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)?.upload ??
                                      'Upload',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ));
                    }),
                  ],
                );
              }),
            ),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.addNewStory,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  Widget _buildImagePreview() {
    final imagePath = context.watch<StoriesProvider>().imagePath;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: kIsWeb
                  ? Image.network(
                      imagePath.toString(),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath.toString()),
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }

  Widget _buildImageButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageButton(
            label: AppLocalizations.of(context)!.gallery,
            onPressed: _onGalleryView,
            colorButton: Colors.purple,
            icon: const Icon(Icons.image_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          CustomImageButton(
            label: AppLocalizations.of(context)!.camera,
            onPressed: _onCameraView,
            colorButton: Colors.deepPurple,
            icon: const Icon(Icons.camera, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.hintDescription,
        labelText: AppLocalizations.of(context)!.description,
        border: const OutlineInputBorder(),
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildGetLocationButton(
      StoriesProvider storiesProvider, LocationProvider locationProvider) {
    bool stateAddress =
        storiesProvider.lat != null && storiesProvider.lon != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              context.goNamed(AppRoutePaths.googleMapsRouteName);
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) => _buildPopupDialog(context),
              // );
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              backgroundColor: Colors.lightBlue,
            ),
            child: isLoadingLocation
                ? const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : locationProvider.address.isEmpty
                    ? const Icon(Icons.location_off,
                        color: Colors.white)
                    : const Icon(Icons.location_on,
                        color: Colors.white),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              stateAddress ? locationProvider.address : 'No Location',
              softWrap: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onUpload() async {
    final storiesProvider = context.read<StoriesProvider>();
    await storiesProvider.addNewStory(
      context: context,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : 'No Description',
    );

    if (storiesProvider.state == StateActivity.hasData) {
      Fluttertoast.showToast(
          msg: storiesProvider.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      storiesProvider.clear();
    } else {
      Fluttertoast.showToast(
          msg: storiesProvider.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      storiesProvider.clear();
    }
  }

  _onGalleryView() async {
    final provider = context.read<StoriesProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<StoriesProvider>();

    final ImagePicker picker = ImagePicker();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Popup example'),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(.6),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(children: [
              GoogleMap(
                markers: markers,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: dicodingOffice,
                  zoom: 15,
                ),
                onMapCreated: (controller) async {
                  final info = await geo.placemarkFromCoordinates(
                      dicodingOffice.latitude, dicodingOffice.longitude);

                  final place = info[0];
                  final street = place.street!;
                  final address =
                      '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                  setState(() {
                    placemark = place;
                  });

                  defineMarker(dicodingOffice, street, address);

                  setState(() {
                    mapController = controller;
                  });
                },
                onTap: (LatLng latLng) => onLongPressGoogleMap(latLng),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
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
            ])),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
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
        print("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
