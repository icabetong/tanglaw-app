// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Tanglaw';

  @override
  String get route_settings => 'Settings';

  @override
  String get route_about => 'About';

  @override
  String get button_load_more => 'Load more';

  @override
  String get button_refresh => 'Refresh';

  @override
  String get placeholder_search => 'Search';

  @override
  String get loading_languages => 'Loading languages...';

  @override
  String get menu_settings => 'Settings';

  @override
  String get menu_about => 'About';

  @override
  String get pref_language => 'Language';

  @override
  String get pref_language_option_en => 'English';

  @override
  String get pref_language_option_fil => 'Filipino';

  @override
  String get pref_setup_offline_use => 'Setup for Offline Use';

  @override
  String get pref_setup_offline_use_desc =>
      'Save drug data for offline use, even in low-signal areas';

  @override
  String get pref_setup_offline_use_loading =>
      'Downloading Medical Database...';

  @override
  String get pref_setup_offline_use_error => 'Download failed, try again later';

  @override
  String get pref_sync_with_server => 'Update Medical Database';

  @override
  String get pref_sync_with_server_desc =>
      'Refresh your local library with the latest pharmaceutical data, dosage updates, and safety advisories from the server.';

  @override
  String get status_no_internet => 'No Connection';

  @override
  String get status_has_internet => 'Connection Established';

  @override
  String get error_generic => 'An Error Occurred';
}
