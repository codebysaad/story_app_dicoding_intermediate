import 'package:flutter/material.dart';
import 'package:story_app/data/preference/preferences_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferenceProvider({required this.preferencesHelper}) {
    _getToken();
    _getLoginState();
  }

  String _authToken = '';
  String get authToken => _authToken;

  String _profileName = '';
  String get profileName => _profileName;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void _getLoginState() async {
    _isLoggedIn = await preferencesHelper.isLoggedIn();
    notifyListeners();
  }

  void _getToken() async {
    _authToken = await preferencesHelper.getToken;
    notifyListeners();
  }

  void getProfileName() async {
    _profileName = await preferencesHelper.getProfileName;
    notifyListeners();
  }

  void saveToken(String value, bool isLoggedIn, String name) {
    preferencesHelper.setToken(value);
    preferencesHelper.setLoginState(isLoggedIn);
    preferencesHelper.setProfileName(name);
    _getToken();
    _getLoginState();
    notifyListeners();
  }
}