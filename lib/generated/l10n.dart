// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Story App`
  String get titleApp {
    return Intl.message(
      'Story App',
      name: 'titleApp',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure to Logout This Account?`
  String get logoutMessage {
    return Intl.message(
      'Are You Sure to Logout This Account?',
      name: 'logoutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Logout Successfully`
  String get logoutSuccess {
    return Intl.message(
      'Logout Successfully',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Add New Story`
  String get addNewStory {
    return Intl.message(
      'Add New Story',
      name: 'addNewStory',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter your story description...`
  String get hintDescription {
    return Intl.message(
      'Enter your story description...',
      name: 'hintDescription',
      desc: '',
      args: [],
    );
  }

  /// `Details Story`
  String get detailStory {
    return Intl.message(
      'Details Story',
      name: 'detailStory',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Data Not Found`
  String get emptyData {
    return Intl.message(
      'Data Not Found',
      name: 'emptyData',
      desc: '',
      args: [],
    );
  }

  /// `Lost Connection`
  String get lostConnection {
    return Intl.message(
      'Lost Connection',
      name: 'lostConnection',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Logging Out...`
  String get loggingOut {
    return Intl.message(
      'Logging Out...',
      name: 'loggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `All fields are required`
  String get allFieldRequired {
    return Intl.message(
      'All fields are required',
      name: 'allFieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Don\'t have an account?`
  String get notHaveAccount {
    return Intl.message(
      'Don\\\'t have an account?',
      name: 'notHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Account`
  String get createAccount {
    return Intl.message(
      'Create Your Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get errorEmptyPassword {
    return Intl.message(
      'Please enter your password',
      name: 'errorEmptyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Must be at least 8 Character`
  String get passwordAtLeast8Char {
    return Intl.message(
      'Password Must be at least 8 Character',
      name: 'passwordAtLeast8Char',
      desc: '',
      args: [],
    );
  }

  /// `Password Mush have Capital Character`
  String get passwordCapital {
    return Intl.message(
      'Password Mush have Capital Character',
      name: 'passwordCapital',
      desc: '',
      args: [],
    );
  }

  /// `Password Not Match!`
  String get passwordNotMatch {
    return Intl.message(
      'Password Not Match!',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Enter your credential to login`
  String get credentialMessage {
    return Intl.message(
      'Enter your credential to login',
      name: 'credentialMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
