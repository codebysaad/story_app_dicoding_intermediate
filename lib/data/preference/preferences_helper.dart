import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {

  static const stateLogin = 'login_state';
  static const stateAuth = 'state_token';
  static const authToken = 'token';

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    // await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateLogin) ?? false;
    // final sPref = await sharedPref;
    // return sPref.getBool(stateLogin) ?? false;
  }

  void setLoginState(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(stateLogin, value);
  }

  Future<bool> get isAuthenticate async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateAuth) ?? false;
  }

  Future<String> get getToken async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(authToken) ?? 'no_auth';
  }

  void setStateAuth(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(stateAuth, value);
  }

  void setToken(String value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(authToken, value);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    preferences.remove(authToken);
    preferences.remove(stateLogin);
    return true;
  }
}