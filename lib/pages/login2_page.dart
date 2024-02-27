import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_text_field.dart';
import 'package:story_app/layouts/loading_animation.dart';
import 'package:story_app/layouts/password_text_field.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/routes/app_route_paths.dart';
import 'package:story_app/utils/state_activity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../layouts/button.dart';
import '../utils/snack_message.dart';

class Login2Page extends StatefulWidget {
  const Login2Page({Key? key}) : super(key: key);

  @override
  State<Login2Page> createState() => _Login2PageState();
}

class _Login2PageState extends State<Login2Page> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: const Text('Login ')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    CustomTextField(
                      hint: "Email",
                      controller: _email,
                    ),
                    PasswordTextField(
                      hint: 'Password',
                      controller: _password,
                    ),

                    ///Button
                    Consumer<AuthProvider>(builder: (context, provider, child) {
                      // switch(provider.state){
                      //   case StateActivity.loading:
                      //     return const LoadingAnimation();
                      //   case StateActivity.noData:
                      //     showMessage(
                      //           message: provider.loginResponse.message, context: context);
                      //   case StateActivity.hasData:
                      //       showMessage(
                      //           message: provider.loginResponse.message, context: context);
                      //       context.go('/${AppRoutePaths.homeRouteName}');
                      //   case StateActivity.error:
                      //     showMessage(
                      //         message: provider.message, context: context);
                      // }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if(provider.state == StateActivity.loading){
                          const LoadingAnimation();
                        } else if(provider.state == StateActivity.hasData){
                          showMessage(
                              message: provider.loginResponse.message, context: context);
                          context.go('/${AppRoutePaths.homeRouteName}');
                        } else if(provider.state == StateActivity.noData){
                          showMessage(
                              message: provider.loginResponse.message, context: context);
                        }
                        // if (provider.message != '') {
                        //   ///Clear the response message to avoid duplicate
                        //   provider.clear();
                        //   if(provider.loginResponse.error == false){
                        //   }
                        // }
                      });
                      return FilledButton(
                        onPressed: () {
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            showMessage(
                                message: "All fields are required",
                                context: context);
                          } else {
                            provider.login(
                                email: _email.text.trim(),
                                password: _password.text.trim());
                          }
                        },
                        child: const Text('Login'),
                      );
                      // return customButton(
                      //   text: 'Login',
                      //   tap: () {
                      //     if (_email.text.isEmpty || _password.text.isEmpty) {
                      //       showMessage(
                      //           message: "All fields are required",
                      //           context: context);
                      //     } else {
                      //       provider.login(
                      //           email: _email.text.trim(),
                      //           password: _password.text.trim());
                      //     }
                      //   },
                      //   context: context,
                      //   status: provider.state,
                      // );
                    }),

                    const SizedBox(
                      height: 10,
                    ),

                    GestureDetector(
                      onTap: () {
                        context.go('/${AppRoutePaths.registerRouteName}');
                      },
                      child: const Text('Register Instead'),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
