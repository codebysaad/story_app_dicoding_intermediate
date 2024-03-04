import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/localization.dart';

import '../providers/localization_provider.dart';

class IconFlagLocale extends StatelessWidget {
  const IconFlagLocale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: const Icon(Icons.flag, color: Colors.white,),
        items: AppLocalizations.supportedLocales.map((Locale locale) {
          final flag = Localization.getFlag(locale.languageCode);
          return DropdownMenuItem(
            value: locale,
            child: Center(
              child: Text(
                flag,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            onTap: () {
              final provider =
              Provider.of<LocalizationProvider>(context, listen: false);
              provider.setLocale(locale);
            },
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
