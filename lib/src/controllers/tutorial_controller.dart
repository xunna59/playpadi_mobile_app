import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/youtube_tutorials_model.dart';

class TutorialService {
  /// Replace with your real endpoint
  static const _baseUrl = 'https://xunnatech.com/api/youtube.json';

  Future<List<TutorialModel>> fetchTutorials() async {
    final resp = await http.get(Uri.parse(_baseUrl));
    if (resp.statusCode != 200) {
      throw Exception('Error fetching tutorials (${resp.statusCode})');
    }
    final List data = json.decode(resp.body) as List;
    return data
        .map((item) => TutorialModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
