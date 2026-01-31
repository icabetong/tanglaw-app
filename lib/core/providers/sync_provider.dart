import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/core/providers/database.dart';
import 'package:tanglaw/core/providers/last_sync_provider.dart';
import 'package:tanglaw/core/repository/drugs.dart';
import 'package:tanglaw/core/store/drugs.dart';
import 'package:tanglaw/shared/models/drug.dart';

class DataSyncNotifier extends AsyncNotifier<void> {
  late final String locale;

  DataSyncNotifier({required this.locale});

  @override
  Future<void> build() async {
    // Initial state is 'null' (idle).
    // We return null because we only care about the side effect of the sync.
    return;
  }

  Future<void> performSync(String? locale) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = ApiClient.getInstance();
      final repository = DrugsRepository.getInstance(client);
      final prefs = await SharedPreferences.getInstance();
      final store = DrugDataStoreLocalized.getLocalizedStore(locale);
      final database = await ref.read(databaseProvider.future);

      final String? lastSync = prefs.getString('last_data_sync_$locale');

      int currentPage = 1;
      int pageCount = 1;
      final List<Drug> allFetchedData = [];

      do {
        final response = await repository.fetchList(
          page: currentPage,
          updatedAt: lastSync,
        );

        allFetchedData.addAll(response.data);
        pageCount = response.meta.paginate?.pageCount ?? 1;
        currentPage++;
      } while (currentPage <= pageCount);

      if (allFetchedData.isNotEmpty) {
        await database.transaction((e) async {
          for (var item in allFetchedData) {
            final String key = item.documentId;
            await store.record(key).put(e, item.toJson());
          }
        });
      }

      await prefs.setString(
        'last_data_sync_$locale',
        DateTime.now().toIso8601String(),
      );

      ref.invalidate(lastSyncProvider(locale ?? 'en'));
    });
  }
}

final syncProvider =
    AsyncNotifierProvider.family<DataSyncNotifier, void, String>((locale) {
      return DataSyncNotifier(locale: locale);
    });
