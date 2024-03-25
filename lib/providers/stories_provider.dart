import 'dart:developer';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/models/data_stories.dart';
import 'package:story_app/data/models/details_story_response.dart';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/maps_response.dart';
import 'package:story_app/data/models/stories_response.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/utils/state_activity.dart';
import 'package:image/image.dart' as img;
import 'package:geocoding/geocoding.dart' as geo;

import '../data/rest/api_services.dart';
import 'location_provider.dart';

class StoriesProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferenceProvider preferenceProvider;
  String? imagePath;
  XFile? imageFile;
  geo.Placemark? placemark;
  String? address;
  double? lat;
  double? lon;

  StoriesProvider(
      {required this.apiServices, required this.preferenceProvider});

  StoriesResponse? _storiesResponse;

  StoriesResponse? get storiesResponse => _storiesResponse;

  List<DataStories> listStories = [];

  final Set<Marker> markers = {};

  late MapsResponse _mapsResponse;

  MapsResponse get mapsResponse => _mapsResponse;

  late DetailsStoryResponse _detailsStoryResponse;

  DetailsStoryResponse get detailsStoryResponse => _detailsStoryResponse;

  late GeneralResponse _addNewStoryResponse;

  GeneralResponse get addNewStoryResponse => _addNewStoryResponse;

  StateActivity _state = const StateActivity.init();

  StateActivity get state => _state;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _message = '';

  String get message => _message;

  int? pageItems = 1;

  int sizeItems = 10;

  void clear() {
    _message = "";
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  List<int> compressImage(List<int> bytes) {
    _isLoading = true;
    notifyListeners();
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = <int>[];

    do {
      compressQuality -= 1000;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  Future<dynamic> getAllStories() async {
    try {
      final token = preferenceProvider.authToken;

      if (pageItems == 1) {
        _state = const StateActivity.loading();
        notifyListeners();
      }

      final responses =
          await apiServices.getAllStories(token, pageItems!, sizeItems);

      _storiesResponse = responses;
      listStories.addAll(_storiesResponse!.listStory);
      _state = const StateActivity.hasData();

      if (_storiesResponse!.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _state = const StateActivity.error();
      notifyListeners();
      _message = 'Error --> $e';
      log('Stories: $e');
    }
  }

  Future<dynamic> getAllStoriesMap() async {
    _isLoading = true;
    _state = const StateActivity.loading();
    notifyListeners();
    try {
      final token = preferenceProvider.authToken;

      final responses = await apiServices.getAllStoriesMaps(token);

      _isLoading = false;
      _state = const StateActivity.hasData();
      _message = responses.message;
      log('Maps: ${responses.listStory[0].name.toString()}');
      _mapsResponse = responses;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _state = const StateActivity.error();
      _message = 'Error --> $e';
      notifyListeners();
    }
  }

  Future<dynamic> getDetailStory({required String id}) async {
    try {
      final token = preferenceProvider.authToken;
      log('Token Stories Prov: $token');

      _isLoading = true;
      _state = const StateActivity.loading();
      notifyListeners();

      final responses = await apiServices.getStoryDetails(token, id);
      _detailsStoryResponse = responses;
      _isLoading = false;
      _state = const StateActivity.hasData();
      _message = responses.message;
      log(responses.story.name.toString());
      log('Detail Story : ${responses.story.lat}');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _state = const StateActivity.error();
      _message = 'Error --> $e';
      log('Exception : $e');
      notifyListeners();
      return _message;
    }
  }

  Future<dynamic> addNewStory({required String description, required BuildContext context}) async {
    _isLoading = true;
    _state = const StateActivity.loading();
    notifyListeners();
    try {
      final token = preferenceProvider.authToken;

      final fileName = imageFile!.name;
      final bytes = await imageFile!.readAsBytes();
      final newBytes = compressImage(bytes);

      final addingStory = await apiServices.addNewStory(
          token, newBytes, description, fileName, lat, lon);
      log('Result: ${addingStory.message}');

      _addNewStoryResponse = addingStory;
      _isLoading = false;
      _state = const StateActivity.hasData();
      _message = addingStory.message;
      setImageFile(null);
      setImagePath(null);
      log('OnSuccess: ${addingStory.message.toString()}');
      if (!context.mounted) return;
      context.pop(true);

      await refreshStory(context);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _state = const StateActivity.error();
      _message = 'Error --> $e';
      log(_message);
      notifyListeners();
      return _message;
    }
  }

  Future<void> refreshStory(BuildContext context) async {
    listStories.clear();
    pageItems = 1;
    sizeItems = 10;
    await getAllStories();
  }

  Future<void> defineMarker(LatLng latLng) async {
    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = info[0];
    final street = place.street!;
    address = '${place.subLocality}, ${place.locality}, ${place.country}';

    markers
      ..clear()
      ..add(
        Marker(
          markerId: const MarkerId('your-loc'),
          position: latLng,
          infoWindow: InfoWindow(
            title: street,
            snippet: address,
          ),
        ),
      );
    notifyListeners();
  }

  void addLocation(BuildContext context) {
    final locProv = context.read<LocationProvider>();
    lat = locProv.initLocation.latitude;
    lon = locProv.initLocation.longitude;
    notifyListeners();
  }
}
