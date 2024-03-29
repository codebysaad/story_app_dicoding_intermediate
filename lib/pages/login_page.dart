import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/password_text_field.dart';
import '../providers/auth_provider.dart';
import '../routes/app_route_paths.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final PreferenceProvider preferenceProv;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();
  bool isPasswdLength8Char = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      preferenceProv = Provider.of<PreferenceProvider>(context, listen: false);
      final token = preferenceProv.authToken;
      log('Init state: $token');
    });
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  final loading = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildList();
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
                width: width * 0.9,
                margin: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)?.welcomeBack ??
                                  'Welcome Back',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(AppLocalizations.of(context)
                                ?.credentialMessage ??
                                ''),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              hint: AppLocalizations.of(context)?.email,
                              controller: _emailController,
                            ),
                            const SizedBox(height: 10),
                            PasswordTextField(
                              hint: AppLocalizations.of(context)?.password,
                              controller: _passwordController,
                              isVisible: isPasswordVisible,
                              onIconPressed: () => setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              }),
                              onChanged: (value) => setState(() {
                                checkPassword(value);
                              }),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorEmptyPassword;
                                }
                                if (!isPasswdLength8Char) {
                                  return AppLocalizations.of(context)!
                                      .passwordAtLeast8Char;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Consumer2<AuthProvider, PreferenceProvider>(builder: (context, authProvider, preference, child){
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) {
                                if (authProvider.message != "") {
                                  if (authProvider.stateLogin == const StateActivityHasData()) {
                                    Fluttertoast.showToast(
                                        msg: authProvider.message,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    authProvider.clear();
                                    context.go(AppRoutePaths.rootRouteName);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: authProvider.message,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    authProvider.clear();
                                  }
                                }
                              });
                              return authProvider.isLoading
                                  ? loading
                                  : ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!
                                      .validate()) {
                                    if (_emailController.text.isEmpty ||
                                        _passwordController
                                            .text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: AppLocalizations.of(
                                              context)!
                                              .allFieldRequired,
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      authProvider.login(context,
                                          email: _emailController.text
                                              .trim(),
                                          password: _passwordController
                                              .text
                                              .trim());
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)?.login ??
                                      'Login',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              );
                            }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)?.notHaveAccount ??
                                ''),
                            TextButton(
                                onPressed: () {
                                  context.go(
                                      '/${AppRoutePaths.loginRouteName}/${AppRoutePaths.registerRouteName}');
                                },
                                child: Text(
                                  AppLocalizations.of(context)?.register ??
                                      'Register',
                                  style:
                                  const TextStyle(color: Colors.blueAccent),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  checkPassword(String password) {
    isPasswdLength8Char = password.length >= 8;
  }

  checkMatchingPassword(String password, String confirmPassword) {
    return password == confirmPassword ? true : false;
  }
}