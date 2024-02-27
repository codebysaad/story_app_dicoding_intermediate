import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/login_response.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/utils/state_activity.dart';

import '../data/preference/preferences_helper.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferencesHelper preferenceHelper;

  AuthProvider({required this.apiServices, required this.preferenceHelper});

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;

  late LoginResponse _loginResponse;
  LoginResponse get loginResponse => _loginResponse;

  late GeneralResponse _registerResponse;
  GeneralResponse get registerResponse => _registerResponse;

  late StateActivity _state;
  StateActivity get state => _state;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isLoggedIn = false;

  void clear() {
    _message = "";
    notifyListeners();
  }

  String _message = '';
  String get message => _message;

  Future<void> init() async {
    isLoggedIn = await preferenceHelper.isLoggedIn();
    notifyListeners();
  }

  Future<dynamic> login(
      {
        required String email, required String password}) async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final authenticating = await apiServices.login(email, password);
      if (authenticating.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        _message = authenticating.message;
        log(message);
        notifyListeners();

        return _loginResponse = authenticating;
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        _message = authenticating.message;
        log(authenticating.loginData.toString());
        notifyListeners();

        return _loginResponse = authenticating;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      _message = 'Error --> $e';
      notifyListeners();
      return _loginResponse = LoginResponse(error: true, message: message, loginData: LoginData(userId: "1", name: "XXX", token: "asdadeassd"));
    }
  }

  Future<dynamic> register(
      {required String name, required String email, required String password}) async {
    try {
      _isLoading = true;
      _state = StateActivity.loading;
      notifyListeners();

      final registering = await apiServices.register(name, email, password);
      if (registering.error == true) {
        _isLoading = false;
        _state = StateActivity.noData;
        notifyListeners();

        return _message = 'Empty Data';
      } else {
        _isLoading = false;
        _state = StateActivity.hasData;
        notifyListeners();

        return _registerResponse = registering;
      }
    } catch (e) {
      _isLoading = false;
      _state = StateActivity.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await preferenceHelper.logout();
      _message = 'Logout Success';
    } catch (e) {
      _message = 'Error --> $e';
      throw Exception('Logout failed: $e');
    }
    // isLoggedIn = await preferenceHelper.isLoggedIn();
    _isLoading = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
