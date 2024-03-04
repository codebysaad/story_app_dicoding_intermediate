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
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late final PreferenceProvider preferenceProv;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.welcomeBack,
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Text(
                            AppLocalizations.of(context)!.back,
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(AppLocalizations.of(context)!.credentialMessage),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        hint: AppLocalizations.of(context)!.email,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 10),
                      PasswordTextField(
                        hint: AppLocalizations.of(context)!.password,
                        controller: _passwordController,
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
                                    fontSize: 16.0);
                                authProvider.clear();
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
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!
                                              .allFieldRequired,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      authProvider.login(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)?.login ?? 'Login',
                                    style: const TextStyle(
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
                      Text(AppLocalizations.of(context)!.notHaveAccount),
                      TextButton(
                          onPressed: () {
                            context.go(
                                '/${AppRoutePaths.loginRouteName}/${AppRoutePaths.registerRouteName}');
                          },
                          child: Text(
                            AppLocalizations.of(context)!.register,
                            style: const TextStyle(color: Colors.blueAccent),
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
