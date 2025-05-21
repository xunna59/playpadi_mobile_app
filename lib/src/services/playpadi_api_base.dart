import 'dart:convert';
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../core/constants.dart';
import './request.dart';
import './response.dart';
import './exceptions.dart';

class APIClient {
  static final APIClient _instance = APIClient._privateConstructor();
  static APIClient get instance => _instance;
  final String baseUrl = 'https://app.playpadi.com';
  late HttpClient _client;

  String? id;
  String? token;
  String? expiry;
  bool isAuthorized = false;

  APIClient._privateConstructor() {
    _client = HttpClient();
    _client.connectionTimeout = const Duration(seconds: 60);
    _loadToken();
  }
  Future<void> loadToken() => _loadToken();

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
        await _saveToken(token!);
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

  Future<dynamic> register(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/auth/register',
      method: 'post',
      headers: ['Content-Type: application/json'],
      body: jsonEncode(data),
    );

    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      //    print(response);
      token = response.data['token'];
      isAuthorized = true;
      _saveToken(token!);

      if (callback is Function) {
        return callback();
      }
    });
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
      _saveToken(token!);

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

  Future<dynamic> updateProfile(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/api/update-profile',
      method: 'put',
      headers: [
        'Content-Type: application/json',
        'Authorization: Bearer $token',
      ],
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

  Future<dynamic> youtubeTutorials([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/academy/fetch-youtube-tutorials',
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

  Future<dynamic> fetchSportsCenterById(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/api/fetch-sports-center/${data['id']}',
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

  Future<dynamic> fetchSlots(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/api/fetch-slots/${data['id']}',
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

  Future<dynamic> fetchAcademyClasses([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/academy/fetch-classes',
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

  Future<dynamic> fetchPublicBookings([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/fetch-bookings/public',
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

  Future<dynamic> addBooking(Map data, [dynamic callback]) async {
    Request payload = Request(
      '${baseUrl}/api/create-booking/${data['sports_center_id']}/${data['court_id']}',
      method: 'post',
      headers: [
        'Content-Type: application/json',
        'Authorization: Bearer $token',
      ],
      body: jsonEncode(data),
    );
    //  print('This is body sent: ${payload.body}');

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

  Future<dynamic> fetchFaqs([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
      '${baseUrl}/api/get-all-faqs',
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
    isAuthorized = false;
    token = null;
  }

  Future<void> logout() async {
    _resetToken();
    await _deleteToken(); // Remove token from storage
  }

  // --- SharedPreferences token persistence ---
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    isAuthorized = token != null;
  }

  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
