import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../playpadi_library.dart';
import '../models/match_model.dart';

class MatchController {
  final APIClient client = APIClient();

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

  Future<List<MatchModel>> getPublicBookings() async {
    try {
      final response = await client.fetchPublicBookings();
      print(response);
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['formattedBookings'] is List) {
          rawList = response['data']['formattedBookings'];
        } else if (response['formattedBookings'] is List) {
          rawList = response['formattedBookings'];
        }
      } else if (response is List) {
        rawList = response;
      }

      final parsed =
          rawList
              .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
              .toList();

      print("Parsed classes: ${parsed.length}");
      return parsed;
    } catch (e, st) {
      print('Error fetching: $e');
      return [];
    }
  }
}
