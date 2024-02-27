import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/layouts/password_text_field.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:story_app/utils/state_activity.dart';

import '../layouts/loading_animation.dart';
import '../layouts/text_message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, provider, __) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                // Page max width
                width: 400.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header
                      const Text("Login"),
                      const SizedBox(height: 16.0),

                      // Inputs
                      CustomTextField(controller: emailController, hint: "Email",),
                      PasswordTextField(
                        hint: 'Password',
                        controller: passwordController,
                        isVisible: isPasswordVisible,
                        onIconPressed: () => setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        }),
                        onChanged: (value) => doLogin(),
                      ),
                      const SizedBox(height: 32.0),

                      FilledButton(
                        onPressed: () => {
                          doLogin()
                        },
                        child: const Text('Login'),
                      ),

                      // Actions
                      // Consumer<AuthProvider>(
                      //   builder: (context, provider, child) {
                          // if (provider.state == StateActivity.loading) {
                          //   return const LoadingAnimation();
                          // }

                      //     return FilledButton(
                      //       onPressed: () {
                      //         provider.login(
                      //             email: emailController.text,
                      //             password: passwordController.text);
                      //
                      //         if(provider.loginResponse.error == false){
                      //           ScaffoldMessenger.of(context)
                      //               .showSnackBar(const SnackBar(content: Text("Berhasil Login")));
                      //         } else {
                      //           ScaffoldMessenger.of(context)
                      //               .showSnackBar(const SnackBar(content: Text("Gagal Login")));
                      //         }
                      //       },
                      //       child: const Text('Login'),
                      //     );
                      //   },
                      //   child: const Center(
                      //       child: LoadingAnimation()),
                      // ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Need an account?'),
                          TextButton(
                            onPressed: () =>
                                context.go('/${AppRoutePaths.registerRouteName}'),
                            child: const Text('Register'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  var doLogin = () {
    // String email = emailController.text;
    //     String password = passwordController.text;
    //   final Future<dynamic> successfulMessage =
    //   provider.login(email: email, password: password);
    //
    //   successfulMessage.then((response) {
    //     if (response['status']) {
    //       User user = response['user'];
    //       Provider.of<UserProvider>(context, listen: false).setUser(user);
    //       Navigator.pushReplacementNamed(context, '/dashboard');
    //     } else {
    //       Flushbar(
    //         title: "Failed Login",
    //         message: response['message']['message'].toString(),
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //     }
    //   });
  };

  // Future<void> doLogin() async {
  //   // final showSnackBar = context.scaffoldMessenger.showSnackBar;
  //   try {
  //     String email = emailController.text;
  //     String password = passwordController.text;
  //
  //     final provider = context.read<AuthProvider>();
  //
  //     provider.login(email: email, password: password);
  //
  //     if(provider.loginResponse.error == false){
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text("Berhasil Login")));
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text("Gagal Login")));
  //     }
  //   } on HttpException catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //     // showSnackBar(SnackBar(
  //     //   content: Text(e.toString()),
  //     // ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No internet connection')));
  //     // showSnackBar(const SnackBar(content: Text('No internet connection')));
  //   }
  // }
}
