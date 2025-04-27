import 'dart:convert';
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
//import '../core/constants.dart';
import './request.dart';
import './response.dart';
import './exceptions.dart';

class APIClient {
  static final APIClient _instance = APIClient._privateConstructor();
  final String baseUrl = 'https://playpadi.xunnatech.com';
  late HttpClient _client;

  String? id;
  String? token;
  String? expiry;
  bool isAuthorized = false;

  APIClient._privateConstructor() {
    _client = HttpClient();
    _client.connectionTimeout = const Duration(seconds: 60);
  }

  factory APIClient() => _instance;

  Future<dynamic> request(
    Request payload, [
    Function(Response)? callback,
  ]) async {
    try {
      // 1) Open & configure
      final HttpClientRequest req = await _client.openUrl(
        payload.method,
        payload.url,
      );
      req.headers.removeAll(HttpHeaders.acceptEncodingHeader);
      for (final header in payload.headers) {
        final parts = header.split(':');
        req.headers.set(parts[0].trim(), parts.sublist(1).join(':').trim());
      }
      if (payload.body != null) {
        req.write(payload.body);
      }

      final HttpClientResponse resp = await req.close();
      final String body = await resp.transform(utf8.decoder).join();

      final apiResp = Response.fromJson(body, httpStatusCode: resp.statusCode);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return callback != null ? callback(apiResp) : apiResp;
      } else {
        throw ServerErrorException(
          apiResp.code != 0 ? apiResp.code : resp.statusCode,
          apiResp.message.isNotEmpty
              ? apiResp.message
              : 'Server returned ${resp.statusCode}',
        );
      }
    } on SocketException {
      // No internet / DNS error
      throw NetworkErrorException(0);
    }
  }

  /// Google Sign-In Integration
  Future<void> signInWithGoogle() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: 'https://playpadi.xunnatech.com/auth/google',
        callbackUrlScheme: 'playpadi',
      );
      print('🔁 Redirect result: $result');
      final uri = Uri.parse(result);
      token = uri.queryParameters['token'];

      if (token != null) {
        isAuthorized = true;
      } else {
        throw TokenNotFoundException();
      }
    } catch (e) {
      if (e is WebAuthException) {
        throw UserCanceledSignInException();
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> login(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/auth/login',
      method: 'post',
      headers: ['Content-Type: application/json'],
      body: jsonEncode(data),
    );

    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }

      token = response.data['token'];
      isAuthorized = true;

      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> validateEmail(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/auth/validate-email',
      method: 'post',
      headers: ['Content-Type: application/json'],
      body: jsonEncode(data),
    );

    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }

      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> fetchProfile([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/fetch-profile',
      method: 'get',
      headers: [
        'Content-Type: application/json',
        'Authorization: Bearer $token',
      ],
      body: null,
    );
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }

      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchSportsCenters([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/fetch-sports-centers',
      method: 'get',
      headers: ['Content-Type: application/json'],
      body: null,
    );
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  void _resetToken() {
    id = '';
    token = '';
    expiry = '';
    isAuthorized = false;
  }

  Future<void> logout() async {
    _resetToken();
  }
}
