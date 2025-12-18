import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required http.Client client,
  }) : _client = client;

  final String baseUrl;
  final http.Client _client;

  Future<dynamic> getJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      _buildUri(path),
      headers: _mergeHeaders(headers),
    );
    return _decodeResponse(response);
  }

  Future<dynamic> postJson(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.post(
      _buildUri(path),
      headers: _mergeHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Uri _buildUri(String path) {
    return Uri.parse(baseUrl).resolve(path);
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    if (headers == null || headers.isEmpty) {
      return _headers();
    }
    return {
      ..._headers(),
      ...headers,
    };
  }

  dynamic _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }
}

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, body: $body)';
  }
}
