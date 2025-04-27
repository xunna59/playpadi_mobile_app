import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../playpadi_library.dart';
import '../models/event_center_model.dart';

final eventCentersProvider = FutureProvider<List<EventCenter>>((ref) {
  return EventCentersController().fetchSportsCenters();
});

class EventCentersController {
  final APIClient client = APIClient();

  Future<List<EventCenter>> fetchSportsCenters() async {
    try {
      final response = await client.fetchSportsCenters();

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
}
