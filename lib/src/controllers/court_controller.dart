import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court_model.dart';

class CourtController {
  final String _url = 'https://xunnatech.com/api/fetch-courts.json';

  Future<List<CourtModel>> fetchCourts() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => CourtModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courts');
    }
  }
}
