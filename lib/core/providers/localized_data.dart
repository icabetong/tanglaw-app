import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/core/repository/drugs.dart';

final localizedDataAvailabilityProvider = FutureProvider.family<int, String>((
  ref,
  locale,
) async {
  final client = ApiClient.getInstance();
  final repository = DrugsRepository.getInstance(client);

  final response = await repository.fetchList(locale: locale);

  return response.meta.paginate?.total ?? 0;
});
