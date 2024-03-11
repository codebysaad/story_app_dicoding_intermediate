import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:story_app/utils/common.dart';

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
            _buildPopupMenuItem(AppLocalizations.of(context)!.profile, Icons.person_2_rounded, OptionItems.profile.index),
            _buildPopupMenuItem(AppLocalizations.of(context)!.settings, Icons.settings, OptionItems.settings.index),
            _buildPopupMenuItem(AppLocalizations.of(context)!.logout, Icons.exit_to_app, OptionItems.logout.index),
          ];
        },
        onSelected:(value) async {
          if(value == 0){
            context.goNamed(AppRoutePaths.profileRouteName);
          }else if(value == 1){
            AppSettings.openAppSettings();
          }else if(value == 2){
            showDialog(context: context, builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.logout),
              content: Text(AppLocalizations.of(context)!.logoutMessage),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    context.pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.yes),
                  onPressed: () async {
                    context.pop();
                    final authRead = context.read<AuthProvider>();
                    final result = await authRead.logout();
                    if(context.mounted){
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.logoutSuccess,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      if (result) context.goNamed(AppRoutePaths.loginRouteName);
                    }
                  },
                ),
              ],
            ));
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