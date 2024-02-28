import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/models/details_story_response.dart';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/stories_response.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/utils/state_activity.dart';

import '../data/rest/api_services.dart';

class StoriesProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferenceProvider preferenceProvider;

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

  void clear() {
    _message = "";
    notifyListeners();
  }

  String _message = '';
  String get message => _message;

  Future<dynamic> getAllStories() async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();
      final token = preferenceProvider.authToken;

      final responses = await apiServices.getAllStories(token);

      if (responses.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        _message = responses.message;
        log(message);
        notifyListeners();

        return _storiesResponse = responses;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        _message = responses.message;
        log(responses.listStory[0].name.toString());
        notifyListeners();

        return _storiesResponse = responses;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      notifyListeners();
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

  Future<dynamic> addNewStory(
      {
        required List<int> bytes, required String description, required String fileName}) async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final token = preferenceProvider.authToken;

      final addingStory = await apiServices.addNewStory(token, bytes, description, fileName);

      if (addingStory.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        _message = addingStory.message;
        log(message);
        notifyListeners();

        return _addNewStoryResponse = addingStory;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        _message = addingStory.message;
        log(addingStory.message.toString());
        notifyListeners();

        return _addNewStoryResponse = addingStory;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      notifyListeners();
      return _message;
    }
  }
}