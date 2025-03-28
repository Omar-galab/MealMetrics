import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({required this.client, required this.baseUrl});

  Future<http.Response> get(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: params);
    return client.get(uri);
  }
}