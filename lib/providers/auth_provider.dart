import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/login_response.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/utils/state_activity.dart';
import 'package:story_app/utils/typedef.dart';

import '../data/preference/preferences_helper.dart';
import '../routes/app_route_paths.dart';

class AuthProvider with ChangeNotifier {
  final ApiServices apiServices;
  final PreferencesHelper preferenceHelper;

  AuthProvider({required this.apiServices, required this.preferenceHelper});

  late LoginResponse _loginResponse;

  LoginResponse get loginResponse => _loginResponse;

  LoginResponse? loginState;

  late GeneralResponse _registerResponse;

  GeneralResponse get registerResponse => _registerResponse;

  StateActivity _state = const StateActivity.init();

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

  Future<void> newLogin(BuildContext context, {required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final authenticating = await apiServices.newLogin(context, email, password);

    if(authenticating!.isEmpty) {
      _isLoading = false;
      // _message = authenticating.message;
      notifyListeners();
      return;
    }

    loginState = LoginResponse.fromJson(authenticating);

    if (!context.mounted) return;
    if (authenticating.containsValue('success')) {
      final preference = context.read<PreferenceProvider>();
      String token = loginState!.loginData.token;
      String name = loginState!.loginData.name;
      preference.saveToken(token, true, name);
      context.go(AppRoutePaths.rootRouteName);
      _isLoading = false;
    } else {
      _message = authenticating['message'];
      _isLoading = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<dynamic> login(BuildContext context,
      {required String email, required String password}) async {
    try {
      _isLoading = true;
      // _state = const StateActivity.loading();
      notifyListeners();

      final authenticating = await apiServices.login(email, password);

      // _loginResponse = authenticating;
      if (!context.mounted) return;
      final preference = context.read<PreferenceProvider>();
      String token = loginState!.loginData.token;
      String name = loginState!.loginData.name;
      preference.saveToken(token, true, name);
      context.go(AppRoutePaths.rootRouteName);
      _isLoading = false;

      loginState = authenticating;
      _isLoading = false;
      // _state = const StateActivity.hasData();
      _message = authenticating.message;
      log(authenticating.loginData.toString());
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      // _state = const StateActivity.error();
      _message = 'Error --> $e';
      notifyListeners();
    }
  }

  Future<dynamic> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      _isLoading = true;
      _state = const StateActivity.loading();
      notifyListeners();

      final registering = await apiServices.register(name, email, password);
      _registerResponse = registering;
      _isLoading = false;
      _state = const StateActivity.hasData();
      _message = registering.message;
      notifyListeners();
      log('Return Success: ${registering.message}');
    } catch (e) {
      _isLoading = false;
      _state = const StateActivity.error();
      log('Return Catch: $e');
      _message = 'Error --> $e';
      notifyListeners();
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
