import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/providers/preference_provider.dart';

import '../layouts/password_text_field.dart';
import '../providers/auth_provider.dart';
import '../routes/app_route_paths.dart';
import '../utils/platform_widget.dart';
import '../utils/snack_message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late final PreferenceProvider preferenceProv;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isPasswordVisible = false;

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
    _email.clear();
    _password.clear();
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
    return Scaffold(
      body: _buildList(),
    );
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome ",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Text(
                            "Back",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text("Enter your credential to login"),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        hint: "Email",
                        controller: _email,
                      ),
                      const SizedBox(height: 10),
                      PasswordTextField(
                        hint: 'Password',
                        controller: _password,
                        isVisible: isPasswordVisible,
                        onIconPressed: () => setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        }),
                        onChanged: (value) => {},
                      ),
                      const SizedBox(height: 20),
                      Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                        return Consumer<PreferenceProvider>(
                            builder: (context, preference, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (authProvider.message != "") {
                              if (authProvider.loginResponse.error) {
                                Fluttertoast.showToast(
                                    msg: authProvider.message,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                authProvider.clear();
                              } else {
                                Fluttertoast.showToast(
                                    msg: authProvider.message,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                // showMessage(
                                //     message: authProvider.message,
                                //     context: context);
                                authProvider.clear();
                                String token =
                                    authProvider.loginResponse.loginData.token;
                                String name =
                                    authProvider.loginResponse.loginData.name;
                                preference.saveToken(token, true, name);
                                context.go(AppRoutePaths.rootRouteName);
                              }
                            }
                          });
                          return authProvider.isLoading
                              ? loading
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_email.text.isEmpty ||
                                        _password.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "All fields are required",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      // showMessage(
                                      //     message: "All fields are required",
                                      //     context: context);
                                    } else {
                                      authProvider.login(
                                          email: _email.text.trim(),
                                          password: _password.text.trim());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                );
                        });
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don\'t have an account? "),
                      TextButton(
                          onPressed: () {
                            context.go(
                                '/${AppRoutePaths.loginRouteName}/${AppRoutePaths.registerRouteName}');
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.blueAccent),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
