import 'dart:convert';

import 'exceptions.dart';

class Response {
  late int code;
  late String status;
  late String message;
  late dynamic data;

  static const String SUCCESS = 'success';
  static const String ERROR = 'error';

  Response({this.code = 0, this.status = ERROR, this.message = '', this.data});

  /// Now accepts an optional named `httpStatusCode`
  Response.fromJson(String jsonText, {int httpStatusCode = 0}) {
    dynamic json;
    try {
      json = jsonDecode(jsonText);
    } catch (_) {
      throw InvalidResponseException();
    }

    // 1) Code: JSON 'code' if present, otherwise fallback to httpStatusCode
    final rawCode = json['code'];
    if (rawCode != null) {
      code =
          (rawCode is int)
              ? rawCode
              : int.tryParse(rawCode.toString()) ?? httpStatusCode;
    } else {
      code = httpStatusCode;
    }

    // 2) Status: JSON 'status' if present, else infer from code
    if (json.containsKey('status') && json['status'] != null) {
      status = json['status'].toString().trim().toLowerCase();
    } else {
      status = (code >= 200 && code < 300) ? SUCCESS : ERROR;
    }

    // 3) Message
    message =
        (json.containsKey('message') && json['message'] != null)
            ? json['message'].toString()
            : '';

    // 4) Data / token / extras
    if (json.containsKey('data')) {
      data = json['data'];
    } else if (json.containsKey('token')) {
      data = {'token': json['token']};
    } else {
      final extras =
          Map<String, dynamic>.from(json)
            ..remove('code')
            ..remove('status')
            ..remove('message');
      data = extras.isNotEmpty ? extras : null;
    }
  }
}
