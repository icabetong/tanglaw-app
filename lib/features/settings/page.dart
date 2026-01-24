import 'package:flutter/material.dart';
import 'package:tanglaw/l10n/app_localizations.dart';
import 'package:tanglaw/shared/widgets/language_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.route_settings)),
      body: ListView(children: [LanguageListTile()]),
    );
  }
}
