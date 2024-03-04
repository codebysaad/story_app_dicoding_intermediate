import 'dart:developer';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:story_app/data/models/details_story_response.dart';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/stories_response.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/utils/state_activity.dart';
import 'package:image/image.dart' as img;

import '../data/rest/api_services.dart';

class StoriesProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferenceProvider preferenceProvider;
  String? imagePath;
  XFile? imageFile;

  StoriesProvider({required this.apiServices, required this.preferenceProvider});

  late StoriesResponse _storiesResponse;
  StoriesResponse get storiesResponse => _storiesResponse;

  late DetailsStoryResponse _detailsStoryResponse;
  DetailsStoryResponse get detailsStoryResponse => _detailsStoryResponse;

  late GeneralResponse _addNewStoryResponse;
  GeneralResponse get addNewStoryResponse => _addNewStoryResponse;

  late StateActivity _state;
  StateActivity get state => _state;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  set message(String value) {
    _message = value;
  }

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
    _isLoading = true;
    _state = StateActivity.loading;
    notifyListeners();
    try {
      final token = preferenceProvider.authToken;

      final responses = await apiServices.getAllStories(token);

      if (responses.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        notifyListeners();
        _message = responses.message;
        log(message);

        return _storiesResponse = responses;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        notifyListeners();
        _message = responses.message;
        log(responses.listStory[0].name.toString());

        return _storiesResponse = responses;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      notifyListeners();
      _message = 'Error --> $e';
      return _message;
    }
  }

  Future<dynamic> getDetailStory({required String id}) async {
    try {
      final token = preferenceProvider.authToken;
      log('Token Stories Prov: $token');

      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final responses = await apiServices.getStoryDetails(token, id);

      if (responses.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        _message = responses.message;
        log(message);
        notifyListeners();
        log('Error : ${responses.message}');

        return _detailsStoryResponse = responses;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        _message = responses.message;
        log(responses.story.name.toString());
        log('Detail Story : ${responses.story}');
        notifyListeners();

        return _detailsStoryResponse = responses;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      log('Exception : $e');
      notifyListeners();
      return _message;
    }
  }

  Future<dynamic> addNewStory({required String description}) async {
    _isLoading = true;
    _state = StateActivity.loading;
    notifyListeners();
    try {
      final token = preferenceProvider.authToken;

      final fileName = imageFile!.name;
      final bytes = await imageFile!.readAsBytes();
      final newBytes = compressImage(bytes);

      final addingStory = await apiServices.addNewStory(token, newBytes, description, fileName);
      log('Result: ${addingStory.message}');

      if (addingStory.error) {
        _isLoading = false;
        _state = StateActivity.noData;
        _message = addingStory.message;
        log('OnFail: $message');
        notifyListeners();

        return _addNewStoryResponse = addingStory;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        _message = addingStory.message;
        setImageFile(null);
        setImagePath(null);
        log('OnSuccess: ${addingStory.message.toString()}');
        notifyListeners();

        return _addNewStoryResponse = addingStory;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      log(_message);
      notifyListeners();
      return _message;
    }
  }
}