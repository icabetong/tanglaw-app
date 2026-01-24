import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/providers/shared_preferences.dart';

class LocaleNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString('locale') ?? 'en';
  }

  Future<void> setLocale(String locale) async {
    final prefs = ref.read(sharedPreferencesProvider);

    await prefs.setString('locale', locale);
    state = AsyncData(locale);
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, String>(() {
  return LocaleNotifier();
});
