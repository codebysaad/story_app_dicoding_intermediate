import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/login_response.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/utils/state_activity.dart';

import '../data/preference/preferences_helper.dart';

class AuthProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferencesHelper preferenceHelper;

  AuthProvider({required this.apiServices, required this.preferenceHelper});

  late LoginResponse _loginResponse;

  LoginResponse get loginResponse => _loginResponse;

  late GeneralResponse _registerResponse;

  GeneralResponse get registerResponse => _registerResponse;

  StateActivity _state = StateActivity.init;

  StateActivity get state => _state;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void clear() {
    _message = "";
    notifyListeners();
  }

  String _message = '';

  String get message => _message;

  Future<void> init() async {
    _isLoggedIn = await preferenceHelper.isLoggedIn();
    log('Status LoggedIn : $isLoggedIn');
    notifyListeners();
  }

  Future<dynamic> login(
      {required String email, required String password}) async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final authenticating = await apiServices.login(email, password);

      _loginResponse = authenticating;
      _isLoading = false;
      _state = StateActivity.hasData;
      _message = authenticating.message;
      log(authenticating.loginData.toString());
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      notifyListeners();
      return _message;
    }
  }

  Future<dynamic> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final registering = await apiServices.register(name, email, password);
      _registerResponse = registering;
      _isLoading = false;
      _state = StateActivity.hasData;
      _message = registering.message;
      notifyListeners();
      log('Return Success: ${registering.message}');
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      notifyListeners();
      log('Return Catch: $e');
      return _message = 'Error --> $e';
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();
    final logout = await preferenceHelper.logout();
    if (logout) {
      await preferenceHelper.deleteUser();
    }
    _isLoggedIn = await preferenceHelper.isLoggedIn();
    _isLoading = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
