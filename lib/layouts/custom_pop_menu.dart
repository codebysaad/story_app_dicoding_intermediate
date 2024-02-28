import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_route_paths.dart';
import '../utils/item_pop_menu.dart';

class CustomPopMenu extends StatelessWidget {
  const CustomPopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (ctx){
          return [
            _buildPopupMenuItem('Profile', Icons.person_2_rounded, OptionItems.profile.index),
            _buildPopupMenuItem('Settings', Icons.settings, OptionItems.settings.index),
            _buildPopupMenuItem('Logout', Icons.exit_to_app, OptionItems.logout.index),
          ];
        },
        onSelected:(value) async {
          if(value == 0){
            print("My account menu is selected.");
          }else if(value == 1){
            print("Settings menu is selected.");
          }else if(value == 2){
            final authRead = context.read<AuthProvider>();
            final result = await authRead.logout();
            if (result) context.goNamed(AppRoutePaths.loginRouteName);
            print("Logout menu is selected.");
          }
        }
    );

  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(iconData, color: Colors.black,),
          Text(title),
        ],
      ),
    );
  }
}