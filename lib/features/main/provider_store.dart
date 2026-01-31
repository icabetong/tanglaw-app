import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/utils/sembast_import_export.dart';
import 'package:tanglaw/core/providers/database.dart';
import 'package:tanglaw/core/store/drugs.dart';
import 'package:tanglaw/shared/models/drug.dart';

final storeProvider =
    FutureProvider.family<List<Drug>, ({String query, String locale})>((
      ref,
      params,
    ) async {
      final database = await ref.watch(databaseProvider.future);
      final store = DrugDataStoreLocalized.getLocalizedStore(params.locale);

      final finder = Finder(
        filter: Filter.or([
          Filter.custom((record) {
            final name = (record['name'] as String).toLowerCase();
            return name.contains(params.query.toLowerCase());
          }),
          Filter.custom((record) {
            final name = (record['genericName'] as String).toLowerCase();
            return name.contains(params.query.toLowerCase());
          }),
          Filter.custom((record) {
            final name = (record['brandNames'] as String).toLowerCase();
            return name.contains(params.query.toLowerCase());
          }),
        ]),
        sortOrders: [SortOrder('name')],
      );

      final result = await store.find(database, finder: finder);

      return result.map((e) => Drug.fromJson(e.value)).toList();
    });
