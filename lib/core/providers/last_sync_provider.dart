import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/providers/shared_preferences.dart';

final lastSyncProvider = FutureProvider.family<DateTime?, String>((
  ref,
  locale,
) async {
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  final lastSync = sharedPreferences.getString("last_data_sync_$locale");

  return lastSync != null ? DateTime.parse(lastSync) : null;
});
