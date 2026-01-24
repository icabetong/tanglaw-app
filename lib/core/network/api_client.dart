import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String endpoint = 'http://10.0.2.2:1337/api';

  Future<dynamic> get(String route) async {
    final target = Uri.parse("$endpoint$route");
    final response = await http.get(target);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load data: ${response.statusCode}");
  }
}
