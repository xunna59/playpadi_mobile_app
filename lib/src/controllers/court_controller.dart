import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../playpadi_library.dart';
import '../models/court_model.dart';
import '../models/event_center_model.dart';

class CourtController {
  final APIClient client = APIClient();

  Future<EventCenter?> fetchCenterById(id) async {
    Map<String, String> data = {'id': id.toString()};

    try {
      final response = await client.fetchSportsCenterById(data);

      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['sportsCenter'] is Map<String, dynamic>) {
          final rawCenter = response['data']['sportsCenter'];
          return EventCenter.fromJson(rawCenter);
        } else if (response['sportsCenter'] is Map<String, dynamic>) {
          final rawCenter = response['sportsCenter'];
          return EventCenter.fromJson(rawCenter);
        }
        return EventCenter.fromJson(response);
      }
      return null;
    } catch (e, st) {
      print('Error: $e');
      return null;
    }
  }
}
