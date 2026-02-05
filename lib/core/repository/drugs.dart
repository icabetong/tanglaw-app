import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/strapi_response.dart';

class DrugsRepository {
  static DrugsRepository? _repository;

  final ApiClient _client;

  DrugsRepository._(this._client);

  static DrugsRepository getInstance(ApiClient client) {
    _repository ??= DrugsRepository._(client);
    return _repository!;
  }

  Future<StrapiResponse<Drug>> fetch(String documentId) async {
    final uri = Uri(path: "/drugs/$documentId");
    final endpoint = uri.toString();
    final document = await _client.get(endpoint);

    return StrapiResponse.fromJson(document, (json) => Drug.fromJson(json));
  }

  Future<StrapiResponse<List<Drug>>> fetchList({
    String? query,
    String? locale,
    int? page = 1,
    int? pageSize = 25,
    String? updatedAt,
  }) async {
    final uri = Uri(
      path: '/drugs',
      queryParameters: {
        'sort[0]': 'name',
        'sort[1]': 'genericName',
        'sort[2]': 'createdAt',

        if (query != null && query.isNotEmpty) ...{
          'filters[\$or][0][name][\$containsi]': query,
          'filters[\$or][1][brandNames][\$containsi]': query,
        },
        if (locale != null && locale.isNotEmpty) 'locale': locale,
        if (page != null) 'pagination[page]': page.toString(),
        if (pageSize != null) 'pagination[pageSize]': pageSize.toString(),
        if (updatedAt != null) 'filters[updatedAt][\$gt]': updatedAt,
      },
    );
    final endpoint = uri.toString();
    final items = await _client.get(endpoint);

    return StrapiResponse.fromJson(
      items,
      (json) => (json as List)
          .map((item) => Drug.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
