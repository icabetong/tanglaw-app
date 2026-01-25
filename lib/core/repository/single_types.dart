import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/strapi_response.dart';

class SingleTypesRepository {
  static SingleTypesRepository? _repository;

  final ApiClient _client;

  SingleTypesRepository._(this._client);

  static SingleTypesRepository getInstance(ApiClient client) {
    _repository ??= SingleTypesRepository._(client);
    return _repository!;
  }

  Future<StrapiResponse<T>> fetchByKey<T extends Object>(
    String key,
    T Function(dynamic json) parser,
  ) async {
    final uri = Uri(path: "/$key");
    final endpoint = uri.toString();
    final document = await _client.get(endpoint);

    return StrapiResponse<T>.fromJson(document, parser);
  }
}
