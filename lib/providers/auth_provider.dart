import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/login_data.dart';
import 'package:story_app/data/models/login_response.dart';
import 'package:story_app/data/rest/api_services.dart';
import 'package:story_app/providers/preference_provider.dart';
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

  StateActivity _stateLogin = const StateActivityInit();

  StateActivity get stateLogin => _stateLogin;

  StateActivity _stateRegister = const StateActivityInit();

  StateActivity get stateRegister => _stateRegister;

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

  Future<dynamic> login(BuildContext context,
      {required String email, required String password}) async {
      _isLoading = true;
      _stateLogin = const StateActivityLoading();
      notifyListeners();

      final authenticating = await apiServices.login(email, password);

      if(authenticating.message == 'success'){
        _loginResponse = authenticating;
        log('Login: $_loginResponse');
        _isLoading = false;
        _isLoggedIn = true;
        _stateLogin = const StateActivityHasData();
        _message = authenticating.message;
        if (!context.mounted) return;
        await saveCredential(context, authenticating.loginData!);
        log(authenticating.loginData.toString());
        notifyListeners();
      } else {
        _isLoading = false;
        _isLoggedIn = false;
        _stateLogin = const StateActivityError();
        _message = authenticating.message;
        log(authenticating.loginData.toString());
        notifyListeners();
      }
  }

  Future<dynamic> register(
      {required String name,
        required String email,
        required String password}) async {

      _isLoading = true;
      _stateRegister = const StateActivityLoading();
      notifyListeners();

      final registering = await apiServices.register(name, email, password);

      if(registering.error){
        _isLoading = false;
        _stateRegister = const StateActivityError();
        _isLoggedIn = false;
        _message = 'Error --> ${registering.message}';
        log('Return Catch: ${registering.message}');
        notifyListeners();
      } else {
        _registerResponse = registering;
        _isLoading = false;
        _isLoggedIn = false;
        _stateRegister = const StateActivityHasData();
        _message = registering.message;
        log('Return Success: ${registering.message}');
        notifyListeners();
      }

  }

  Future<void> saveCredential(BuildContext context, LoginData loginData) async {
    final preference = context.read<PreferenceProvider>();
    log('LoginData: $loginData');
    String token = loginData.token;
    String name = loginData.name;
    preference.saveToken(token, true, name);
    notifyListeners();
    }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();
    await preferenceHelper.logout();
    _isLoggedIn = await preferenceHelper.isLoggedIn();
    _isLoading = false;
    notifyListeners();
    return !isLoggedIn;
  }
}