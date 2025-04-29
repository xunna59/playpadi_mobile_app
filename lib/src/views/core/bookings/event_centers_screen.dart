import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/event_center_card.dart';
import '../../../widgets/inkwell_modal.dart';
import '../../../providers/eventCentersProvider.dart';

class EventCentersScreen extends ConsumerWidget {
  const EventCentersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of event centers
    final centersAsync = ref.watch(eventCentersProvider);

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
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    // Show filter modal
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Padel',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // Sport selection
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Today 3pm - 8pm',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // Time range selection
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Event centers list with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(eventCentersProvider.future),
                child: centersAsync.when(
                  data: (centers) {
                    if (centers.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(child: Text('No centers found')),
                        ],
                      );
                    }
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
