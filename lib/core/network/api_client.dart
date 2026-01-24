import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static ApiClient? _client;
  final String _endpoint = 'http://10.0.2.2:1337/api';

  static ApiClient getInstance() {
    _client ??= ApiClient();
    return _client!;
  }

  Future<dynamic> get(String route) async {
    final target = Uri.parse("$_endpoint$route");
    final response = await http.get(target);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load data: ${response.statusCode}");
  }
}
