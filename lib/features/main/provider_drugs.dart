import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/drugs_api.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/paginated.dart';

final drugProvider = FutureProvider.family<Paginated<Drug>, String>((
  ref,
  query,
) async {
  final client = ApiClient.getInstance();
  final api = DrugsApi(client);

  final drugs = await api.fetchDrugs(query: query);
  return drugs;
});
