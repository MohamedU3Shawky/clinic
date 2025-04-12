import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  static const String baseUrl =
      'https://bk.potentialeg.com'; // Replace with your actual API base URL

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add any authentication headers here
      },
    );
  }

  static Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add any authentication headers here
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add any authentication headers here
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add any authentication headers here
      },
    );
  }
}
