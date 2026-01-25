import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/repository/drugs.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/strapi_response.dart';

final drugProvider =
    FutureProvider.family<
      StrapiResponse<List<Drug>>,
      ({String query, String locale})
    >((ref, params) async {
      final client = ApiClient.getInstance();
      final repository = DrugsRepository.getInstance(client);

      final drugs = await repository.fetchList(
        query: params.query,
        locale: params.locale,
      );
      return drugs;
    });
