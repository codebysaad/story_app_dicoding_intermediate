import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/layouts/password_text_field.dart';
import 'package:story_app/providers/auth_provider.dart';

import '../utils/platform_widget.dart';
import '../utils/snack_message.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isObsecured = true;

  bool isPasswdLength8Char = false;
  bool isPasswdContainCapital = false;
  bool isConfirmPasswdLength8Char = false;
  bool isConfirmPasswdContainCapital = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordMatch = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create your account",
                          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 12.0),
                        CustomTextField(
                          controller: _usernameController,
                          hint: 'Username',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          hint: 'Password',
                          isVisible: isPasswordVisible,
                          controller: _passwordController,
                          onIconPressed: () => setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          }),
                          onChanged: (value) => setState(() {
                            checkPassword(value);
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            if (!isPasswdLength8Char) {
                              return "Password Must be at least 8 Character";
                            }
                            if (!isPasswdContainCapital) {
                              return "Password Mush have Capital Character";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordTextField(
                          hint: 'Confirm Password',
                          isVisible: isConfirmPasswordVisible,
                          controller: _confirmPasswordController,
                          onIconPressed: () => setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          }),
                          onChanged: (value) => setState(() {
                            checkConfirmPassword(value);
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            if (!isConfirmPasswdLength8Char) {
                              return "Password Must be at least 8 Character";
                            }
                            if (!isConfirmPasswdContainCapital) {
                              return "Password Mush have Capital Character";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Consumer<AuthProvider>(builder: (context, provider, child) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (provider.message != "") {
                          if (provider.loginResponse.error) {
                            Fluttertoast.showToast(
                                msg: provider.message,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            // showMessage(
                            //     message: provider.message, context: context);
                            provider.clear();
                          } else {
                            Fluttertoast.showToast(
                                msg: provider.message,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            // showMessage(
                            //     message: provider.message, context: context);
                            provider.clear();
                            context.pop(true);
                          }
                        }
                      });
                      return provider.isLoading
                          ? loading
                          : Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (checkMatchingPassword(
                                    _passwordController.text,
                                    _confirmPasswordController.text)) {
                                  provider.register(
                                      name: _usernameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Password Not Match!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  // showMessage(
                                  //     message: "Password Not Match!",
                                  //     context: context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ));
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.blueAccent),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkPassword(String password) {
    isPasswdLength8Char = password.length >= 8;
    isPasswdContainCapital = password.contains(RegExp(r'[A-Z]'));
  }

  checkConfirmPassword(String password) {
    isConfirmPasswdLength8Char = password.length >= 8;
    isConfirmPasswdContainCapital = password.contains(RegExp(r'[A-Z]'));
  }

  checkMatchingPassword(String password, String confirmPassword) {
    return password == confirmPassword ? true : false;
  }
}
