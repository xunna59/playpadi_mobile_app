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
    final centersAsync = ref.watch(eventCentersProvider);

    // Function to refresh the data
    Future<void> _reloadData(WidgetRef ref) async {
      ref.refresh(eventCentersProvider);
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

            // Use RefreshIndicator for pull-to-refresh functionality
            Expanded(
              child: RefreshIndicator(
                // 1) Return the Future that completes when the provider finishes fetching
                onRefresh: () => ref.refresh(eventCentersProvider.future),
                // 2) Always wrap each branch in a scrollable with AlwaysScrollableScrollPhysics
                child: centersAsync.when(
                  data: (centers) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: centers.length,
                      itemBuilder: (context, index) {
                        final center = centers[index];
                        return GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.eventCenterDetails,
                                arguments: center,
                              ),
                          child: EventCenterCard(eventCenter: center),
                        );
                      },
                    );
                  },
                  loading: () {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                  error: (e, _) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 200),
                        Center(child: Text('Error: $e')),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
