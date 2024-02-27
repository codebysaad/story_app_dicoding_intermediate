import 'package:flutter/material.dart';
import 'package:story_app/sample/routes/user_model.dart';

class Profile extends StatelessWidget {
  final UserModel userModel;

  const Profile({Key? key,  required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Center(
            child: Text('Profile'),
          ),
          Text(userModel.id),
          Text(userModel.username)
        ],
      ),
    );
  }
}