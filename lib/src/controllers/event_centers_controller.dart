import '../../playpadi_library.dart';
import '../models/event_center_model.dart';

class EventCentersController {
  final APIClient client = APIClient();

  Future<List<EventCenter>> fetchSportsCenters() async {
    try {
      final response = await client.fetchSportsCenters();
      print(response);

      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        // Case A: { data: { sportsCenters: [...] } }
        if (response['data'] is Map<String, dynamic> &&
            response['data']['sportsCenters'] is List) {
          rawList = response['data']['sportsCenters'];
        } else if (response['sportsCenters'] is List) {
          rawList = response['sportsCenters'];
        }
      }
      // Case C: Direct list returned
      else if (response is List) {
        rawList = response;
      }

      // 3) Map to model objects, or return empty list
      return rawList
          .map((e) => EventCenter.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      // Log and return empty to keep UI responsive
      return [];
    }
  }

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
      return null;
    }
  }
}
