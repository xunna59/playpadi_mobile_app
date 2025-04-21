import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/event_centers_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/event_center_card.dart';
import '../../../widgets/inkwell_modal.dart';

class EventCentersScreen extends ConsumerWidget {
  const EventCentersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of event centers
    final eventCentersState = ref.watch(eventCentersControllerProvider);

    // Ensure fetching data when screen loads if it's not already fetched
    if (eventCentersState is AsyncLoading) {
      ref.read(eventCentersControllerProvider.notifier).fetchEventCenters();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sports Centers')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Filtering dropdowns (sport type, time, etc.)
            Row(
              children: [
                // Filter icon
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    // Show filter modal, etc.
                  },
                ),

                // Spacing
                const SizedBox(width: 8),

                // Sport Chip
                CustomFilterChip(
                  label: 'Padel',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // e.g., show the sport selection sheet
                  },
                ),

                const SizedBox(width: 8),

                // Time Chip
                CustomFilterChip(
                  label: 'Today 3pm - 8pm',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // e.g., show the time range selection
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Event Centers List (handle loading, error, or success states)
            Expanded(
              child: eventCentersState.when(
                data: (eventCenters) {
                  return ListView.builder(
                    itemCount: eventCenters.length,
                    itemBuilder: (context, index) {
                      // Wrap EventCenterCard with GestureDetector or InkWell for navigation
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.eventCenterDetails,
                            arguments:
                                eventCenters[index], // Pass the event center data as arguments
                          );
                        },
                        child: EventCenterCard(
                          eventCenter: eventCenters[index],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
