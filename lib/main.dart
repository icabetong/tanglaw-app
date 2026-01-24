import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanglaw/core/providers/shared_preferences.dart';
import 'package:tanglaw/features/main/page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tanglaw/l10n/app_localizations.dart';
import 'package:tanglaw/features/settings/provider_locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const TanglawApp(),
    ),
  );
}

class TanglawApp extends ConsumerWidget {
  const TanglawApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);

    return MaterialApp(
      title: "Tanglaw",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MainScreen(title: 'Tanglaw'),
      locale: localeAsync.whenOrNull(data: (locale) => Locale(locale)),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('tl')],
    );
  }
}
