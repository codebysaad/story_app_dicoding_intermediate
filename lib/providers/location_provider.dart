import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/utils/state_activity.dart';

import '../utils/common.dart';

class LocationProvider extends ChangeNotifier {
  LatLng initLocation = const LatLng(-6.847937, 110.9274667);

  final Set<Marker> markers = {};
  MapType selectedMapType = MapType.normal;
  StateActivity state = StateActivity.init;

  geo.Placemark? placemark;
  String address = '';

  void defineMarker(LatLng latLng, String street, String address) {
    markers
      ..clear()
      ..add(
        Marker(
          markerId: const MarkerId('location'),
          position: latLng,
          infoWindow: InfoWindow(
            title: street,
            snippet: address,
          ),
        ),
      );
    notifyListeners();
  }

  Future<void> getMyLocation(
    BuildContext context,
    GoogleMapController mapController,
  ) async {
    final locProv = context.read<LocationProvider>();
    final location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (!context.mounted) return;
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.locationServiceUnavailable,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (!context.mounted) return;
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.locationPermissionDenied,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    }

    state = StateActivity.loading;
    notifyListeners();

    locationData = await location.getLocation();

    locProv.initLocation =
        LatLng(locationData.latitude!, locationData.longitude!);
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    address = '${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}';
    placemark = place;

    defineMarker(latLng, street, address);
    try {
      await mapController.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    } catch (e) {
      return;
    }

    state = StateActivity.hasData;
    notifyListeners();
    return;
  }

  Future<void> onTapMap(
    BuildContext context,
    GoogleMapController mapController,
    LatLng latLng,
  ) async {
    final locProv = context.read<LocationProvider>();

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    address = '${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}';

    placemark = place;
    notifyListeners();

    locProv.initLocation = LatLng(latLng.latitude, latLng.longitude);
    debugPrint(locProv.initLocation.toString());

    defineMarker(latLng, street, address);

    await mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
