import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/event_center_card.dart';
import '../../../widgets/inkwell_modal.dart';
import '../../../providers/eventCentersProvider.dart';
import '../../../widgets/show_filter_modal.dart';
import '../../../widgets/sport_modal_widget.dart';

class EventCentersScreen extends ConsumerStatefulWidget {
  const EventCentersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EventCentersScreen> createState() => _EventCentersScreenState();
}

class _EventCentersScreenState extends ConsumerState<EventCentersScreen> {
  String selectedSport = 'Padel';
  String selectedTime = 'Today 3pm - 8pm';

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(eventCentersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sports Centers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    showFilterModal(context);
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: selectedSport,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () async {
                    // You could modify showSelectSportModal to return the selected sport
                    showSelectSportModal(context); // or await and update state
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: selectedTime,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // You can implement a time selector
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

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
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.eventCenterDetails,
                              arguments: center,
                            );
                          },
                          child: EventCenterCard(eventCenter: center),
                        );
                      },
                    );
                  },
                  loading:
                      () => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                  error:
                      (e, _) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 200),
                          Center(child: Text('Error: $e')),
                        ],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
