import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/event_centers_controller.dart';
import '../models/event_center_model.dart';

final eventCentersProvider = FutureProvider<List<EventCenter>>((ref) async {
  final controller = EventCentersController();
  return controller.fetchSportsCenters(); // <== This fetches the list
});
