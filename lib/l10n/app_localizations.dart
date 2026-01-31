import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Tanglaw'**
  String get app_name;

  /// No description provided for @route_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get route_settings;

  /// No description provided for @route_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get route_about;

  /// No description provided for @button_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get button_load_more;

  /// No description provided for @button_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get button_refresh;

  /// No description provided for @placeholder_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get placeholder_search;

  /// No description provided for @loading_languages.
  ///
  /// In en, this message translates to:
  /// **'Loading languages...'**
  String get loading_languages;

  /// No description provided for @menu_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menu_settings;

  /// No description provided for @menu_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menu_about;

  /// No description provided for @pref_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get pref_language;

  /// No description provided for @pref_language_option_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get pref_language_option_en;

  /// No description provided for @pref_language_option_fil.
  ///
  /// In en, this message translates to:
  /// **'Tagalog'**
  String get pref_language_option_fil;

  /// No description provided for @pref_language_option_ilo.
  ///
  /// In en, this message translates to:
  /// **'Ilocano'**
  String get pref_language_option_ilo;

  /// No description provided for @pref_language_option_ceb.
  ///
  /// In en, this message translates to:
  /// **'Cebuano/Bisaya'**
  String get pref_language_option_ceb;

  /// No description provided for @pref_setup_offline_use.
  ///
  /// In en, this message translates to:
  /// **'Download Content'**
  String get pref_setup_offline_use;

  /// No description provided for @pref_setup_offline_use_desc.
  ///
  /// In en, this message translates to:
  /// **'Save drug data for offline use, even in low-signal areas'**
  String get pref_setup_offline_use_desc;

  /// No description provided for @pref_setup_offline_use_loading.
  ///
  /// In en, this message translates to:
  /// **'Downloading Medical Database...'**
  String get pref_setup_offline_use_loading;

  /// No description provided for @pref_setup_offline_use_error.
  ///
  /// In en, this message translates to:
  /// **'Download failed, try again later'**
  String get pref_setup_offline_use_error;

  /// No description provided for @pref_sync_with_server.
  ///
  /// In en, this message translates to:
  /// **'Update Medical Database'**
  String get pref_sync_with_server;

  /// No description provided for @pref_sync_with_server_desc.
  ///
  /// In en, this message translates to:
  /// **'Refresh your local library with the latest pharmaceutical data, dosage updates, and safety advisories from the server.'**
  String get pref_sync_with_server_desc;

  /// No description provided for @status_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get status_no_internet;

  /// No description provided for @status_has_internet.
  ///
  /// In en, this message translates to:
  /// **'Connection Established'**
  String get status_has_internet;

  /// No description provided for @status_no_drugs.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get status_no_drugs;

  /// No description provided for @status_no_results.
  ///
  /// In en, this message translates to:
  /// **'There\'s no results for the query'**
  String get status_no_results;

  ///
  ///
  /// In en, this message translates to:
  /// **'Last download: {date}'**
  String status_last_sync_date(String date);

  /// A general-purpose description field used for providing additional information or context about an item, feature, or entity within the application. This field accepts plain text and can be left empty if no description is needed.
  ///
  /// In en, this message translates to:
  /// **'{count} total items'**
  String status_n_available(int count);

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get error_generic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
