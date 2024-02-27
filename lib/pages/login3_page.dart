import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/providers/preference_provider.dart';

import '../layouts/password_text_field.dart';
import '../providers/auth_provider.dart';
import '../routes/app_route_paths.dart';
import '../utils/platform_widget.dart';
import '../utils/snack_message.dart';

class Login3Page extends StatefulWidget {
  const Login3Page({super.key});

  @override
  _Login3Page createState() => _Login3Page();
}

class _Login3Page extends State<Login3Page> {
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
      // redirectHome(token);
      log('Init state: $token');
    });
    // Future.microtask(() async {
    //   try {
    //
    //
    //   } on Exception catch (e) {
    //     debugPrint('$e - ${e.toString()}');
    //   } catch (e) {
    //     debugPrint('$e');
    //   }
    // });
  }

  // redirectHome(String token) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(
  //         token,
  //         style: const TextStyle(color: Color(0xffFFFFFF)),
  //       ),
  //       backgroundColor: const Color(0xff742DDD)));
  //   if(token != ""){
  //     context.go('/${AppRoutePaths.homeRouteName}');
  //     log('Status login: ${preferenceProv.isLoggedIn.toString()}');
  //   }
  // }

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

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Story App'),
          ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        // middle: Text('Story App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildList() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text("Enter your credential to login"),
                ],
              ),
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
                  const SizedBox(height: 10),
                  Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                    return Consumer<PreferenceProvider>(
                        builder: (context, preference, child) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (authProvider.message != "") {
                          if (authProvider.loginResponse.error) {
                            showMessage(
                                message: authProvider.message,
                                context: context);
                            authProvider.clear();
                          } else {
                            showMessage(
                                message: authProvider.message,
                                context: context);
                            authProvider.clear();
                            String token = authProvider.loginResponse.loginData.token;
                            preference.saveToken(token, true);
                            context.go('/');
                          }
                        }
                      });
                      return authProvider.isLoading
                          ? loading
                          : ElevatedButton(
                              onPressed: () {
                                if (_email.text.isEmpty ||
                                    _password.text.isEmpty) {
                                  showMessage(
                                      message: "All fields are required",
                                      context: context);
                                } else {
                                  authProvider.login(
                                      email: _email.text.trim(),
                                      password: _password.text.trim());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.purple,
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
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don\'t have an account? "),
                  TextButton(
                      onPressed: () {
                        context.go('/${AppRoutePaths.loginRouteName}/${AppRoutePaths.registerRouteName}');
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.purple),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
