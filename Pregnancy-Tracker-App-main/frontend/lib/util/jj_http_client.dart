import 'dart:io';
import 'package:frontend/local_data/shared_preferences/jj_shared_preferences_service.dart';
import 'package:http/http.dart' as http;

// Custom HTTP client to streamline the HTTP requests.
class JJHttpClient {
  static String baseUrl = "http://localhost:3000/";

  final http.Client _httpClient = http.Client();
  final SharedPreferenceService sharedPreferenceService =
      SharedPreferenceService();

  String? _authToken;

  JJHttpClient();

  set authToken(String? value) {
    _authToken = value;
  }

  Future<http.Response> get(String url,
      {Map<String, String> headers = const {}}) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    return _httpClient.get(
      (baseUrl + url).uri,
      headers: headersWithContentTypeAndAuth,
    );
  }

  Future<http.Response> post(String url,
      {Map<String, String> headers = const <String, String>{},
      Object? body,
      String contentType = "application/json"}) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      'Content-Type': contentType,
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    print("POSTING TO: " + (baseUrl + url).uri.toString());
    return _httpClient.post(
      (baseUrl + url).uri,
      headers: headersWithContentTypeAndAuth,
      body: body,
    );
  }

  Future<http.Response> put(String url,
      {Map<String, String> headers = const {},
      Object? body,
      String contentType = "application/json"}) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      'Content-Type': contentType,
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    return _httpClient.put(
      (baseUrl + url).uri,
      headers: headersWithContentTypeAndAuth,
      body: body,
    );
  }

  Future<http.Response> patch(String url,
      {Map<String, String> headers = const {},
      Object? body,
      String contentType = "application/json"}) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      'Content-Type': contentType,
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    return _httpClient.patch(
      (baseUrl + url).uri,
      headers: headersWithContentTypeAndAuth,
      body: body,
    );
  }

  Future<http.Response> delete(String url,
      {Map<String, String> headers = const {},
      Object? body,
      String contentType = "application/json"}) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      'Content-Type': contentType,
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    return _httpClient.delete(
      (baseUrl + url).uri,
      headers: headersWithContentTypeAndAuth,
      body: body,
    );
  }

  Future<http.StreamedResponse> multiPartRequest(
    String url,
    String method, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    Map<String, File> files = const {},
  }) async {
    _authToken = await sharedPreferenceService.getAccessToken();
    Map<String, String> headersWithContentTypeAndAuth = {
      ...headers,
      'Content-Type': "multipart/form-data",
      if (_authToken != null) 'Authorization': 'Bearer $_authToken'
    };

    var request = http.MultipartRequest(method, Uri.parse(baseUrl + url));

    // Add headers
    request.headers.addAll(headersWithContentTypeAndAuth);

    // Add files to the request.
    if (files.isNotEmpty) {
      files.forEach((key, value) async {
        request.files.add(await http.MultipartFile.fromPath(key, value.path));
      });
    }

    // Add body to the request.
    if (body.isNotEmpty) {
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });
    }

    return await request.send();
  }
}

extension UriParsing on String {
  Uri get uri => Uri.parse(this);
}
