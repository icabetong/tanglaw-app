import 'package:flutter/material.dart';
import 'package:tanglaw/l10n/app_localizations.dart';
import 'package:tanglaw/shared/widgets/settings_tiles/language_list_tile.dart';
import 'package:tanglaw/shared/widgets/settings_tiles/download_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.route_settings)),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          LanguageListTile(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.pref_setup_offline_use,
              textAlign: .start,
              style: TextTheme.of(context).labelMedium,
            ),
          ),
          DownloadContentListTile(
            title: AppLocalizations.of(context)!.pref_language_option_en,
            locale: 'en',
          ),
          DownloadContentListTile(
            title: AppLocalizations.of(context)!.pref_language_option_fil,
            locale: 'fil',
          ),
        ],
      ),
    );
  }
}
