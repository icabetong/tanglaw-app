import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/paginated.dart';

class DrugsApi {
  DrugsApi(this.client);

  final ApiClient client;

  Future<Paginated<Drug>> fetchDrugs({String? query}) async {
    String endpoint = '/drugs';
    if (query != null && query.isNotEmpty) {
      endpoint = '/drugs?filters[name][\$contains]=$query';
    }
    final items = await client.get(endpoint);

    return Paginated.fromJson(items, Drug.fromJson);
  }
}
