import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_center_model.dart';

class EventCentersController
    extends StateNotifier<AsyncValue<List<EventCenter>>> {
  EventCentersController() : super(const AsyncLoading());

  // Simulate API call and fetch event centers
  Future<void> fetchEventCenters() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      final List<EventCenter> eventCenters = [
        EventCenter(
          name: 'The Pollen Club',
          location: '25mi - Manchester Greater Manchester',
          price: '\$55/1h',
          availableTimes: ['07:30', '08:00', '08:30', '09:00'],
        ),
        EventCenter(
          name: 'We Are Padel - Derby',
          location: '5km - Derby',
          price: '\$40/1h',
          availableTimes: ['07:30', '08:00', '08:30', '09:00'],
        ),
        EventCenter(
          name: 'Ace Padel Club',
          location: '10mi - London',
          price: '\$45/1h',
          availableTimes: ['08:00', '09:00', '10:00', '11:00'],
        ),
        // Add more dummy data as needed
      ];

      state = AsyncData(eventCenters); // Set state with fetched event centers
    } catch (e, stackTrace) {
      state = AsyncError('Failed to load event centers', stackTrace);
    }
  }

  // Filter event centers based on the search query
  // void filterEventCenters(String query) {
  //   final filtered = state.when(
  //     data: (data) {
  //       // Cast the dynamic data to List<EventCenter>
  //       final List<EventCenter> eventCenters = List<EventCenter>.from(data);
  //       // Filter the event centers based on the query
  //       return eventCenters
  //           .where(
  //             (center) =>
  //                 center.name.toLowerCase().contains(query.toLowerCase()),
  //           )
  //           .toList(); // Ensures the list is of type List<EventCenter>
  //     },
  //     loading: () => <EventCenter>[],
  //     error: (_, __) => <EventCenter>[],
  //   );

  //   // Update the state with the filtered event centers
  //   state = AsyncData(filtered); // Set filtered result as AsyncData
  // }
}

// Provider for EventCentersController
final eventCentersControllerProvider = StateNotifierProvider<
  EventCentersController,
  AsyncValue<List<EventCenter>>
>((ref) => EventCentersController());
