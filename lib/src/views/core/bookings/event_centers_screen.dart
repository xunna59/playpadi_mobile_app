import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/event_center_model.dart';
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
  String? selectedSport;
  String selectedTime = 'Today 3pm - 8pm';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => showFilterModal(context),
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: selectedSport ?? 'All Sports',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () async {
                    final sport = await showSelectSportModal(context);
                    if (sport != null) {
                      setState(() {
                        selectedSport = sport;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: selectedTime,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // Implement time selector
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
                    final query = _searchController.text.toLowerCase();

                    final filteredCenters =
                        centers.where((center) {
                          final matchesSearch =
                              center.name.toLowerCase().contains(query) ||
                              center.address.toLowerCase().contains(query);

                          // Ensure center.sports is not null and contains selectedSport
                          final matchesSport =
                              selectedSport == null ||
                              center.games
                                  .map((s) => s.toLowerCase())
                                  .contains(selectedSport!.toLowerCase());

                          return matchesSearch && matchesSport;
                        }).toList();

                    if (filteredCenters.isEmpty) {
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
                      itemCount: filteredCenters.length,
                      itemBuilder: (context, index) {
                        final center = filteredCenters[index];
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
