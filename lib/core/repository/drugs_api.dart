import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/paginated.dart';

class DrugsRepository {
  DrugsRepository(this.client);

  final ApiClient client;

  Future<Paginated<Drug>> fetchDrugs({String? query, String? locale}) async {
    final uri = Uri(
      path: '/drugs',
      queryParameters: {
        if (query != null && query.isNotEmpty)
          'filters[name][\$contains]': query,
        if (locale != null && locale.isNotEmpty) 'locale': locale,
      },
    );
    final endpoint = uri.toString();
    final items = await client.get(endpoint);

    return Paginated.fromJson(items, Drug.fromJson);
  }
}
