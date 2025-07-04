import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/event_centers_controller.dart';
import '../models/event_center_model.dart';

final eventCentersProvider = FutureProvider<List<EventCenter>>((ref) async {
  final controller = EventCentersController();
  return controller.fetchSportsCenters(); // <== This fetches the list
});

final eventCenterProvider =
    StateNotifierProvider<EventCenterNotifier, List<EventCenter>>((ref) {
      return EventCenterNotifier();
    });

class EventCenterNotifier extends StateNotifier<List<EventCenter>> {
  EventCenterNotifier() : super([]);

  void setEventCenters(List<EventCenter> centers) {
    state = centers;
  }

  Future<void> addToFavorites(int? id) async {
    final payload = {'sports_center_id': id.toString()};

    try {
      await EventCentersController().addToFavourite(payload);
      // Update local state
      state = [
        for (final ec in state)
          if (ec.id == id) ec.copyWith(isFavourite: true) else ec,
      ];
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int? id) async {
    final payload = {'sports_center_id': id.toString()};

    try {
      await EventCentersController().removeFromFavourite(payload);
      // Update local state
      state = [
        for (final ec in state)
          if (ec.id == id) ec.copyWith(isFavourite: false) else ec,
      ];
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }
}

final selectedEventCenterProvider = StateProvider<EventCenter?>((ref) => null);
