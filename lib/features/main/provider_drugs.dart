import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/repository/drugs_api.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/paginated.dart';

final drugProvider =
    FutureProvider.family<Paginated<Drug>, ({String query, String locale})>((
      ref,
      params,
    ) async {
      final client = ApiClient.getInstance();
      final api = DrugsRepository(client);

      final drugs = await api.fetchDrugs(
        query: params.query,
        locale: params.locale,
      );
      return drugs;
    });
