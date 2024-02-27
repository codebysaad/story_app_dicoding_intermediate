import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/preference/preferences_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferenceProvider({required this.preferencesHelper}) {
    _getToken();
    _getLoginState();
  }

  String _authToken = '';
  String get authToken => _authToken;

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

  // Future<bool> isLoggedIn() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(tokenKey) != null;
  // }

  void saveToken(String value, bool isLoggedIn) {
    preferencesHelper.setToken(value);
    preferencesHelper.setLoginState(isLoggedIn);
    _getToken();
    _getLoginState();
    notifyListeners();
  }
}