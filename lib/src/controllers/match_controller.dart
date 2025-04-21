import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';

class MatchController {
  final String _url =
      'https://xunnatech.com/api/matches.json'; // Replace with your API URL

  Future<List<MatchModel>> fetchMatches() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MatchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load matches');
    }
  }
}
