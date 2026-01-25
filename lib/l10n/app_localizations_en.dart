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
}
