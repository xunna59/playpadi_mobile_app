import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/match_provider.dart';
import '../../../widgets/available_matches_card.dart';

class AvailableMatchesScreen extends ConsumerWidget {
  const AvailableMatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchData = ref.watch(matchesFutureProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔒 Fixed Filter Chips Row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, label: 'Padel', selected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, label: '24 Clubs'),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, label: 'Today'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    context,
                    label: 'Clear',
                    backgroundColor: Colors.grey[200],
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(matchesFutureProvider);
                await ref.read(matchesFutureProvider.future);
              },
              child: matchData.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data:
                    (matches) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              'All Available Matches',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: matches.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder:
                                (context, i) =>
                                    AvailableMatchCard(match: matches[i]),
                          ),
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Request Your Place',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children:
                                  matches.map((match) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: SizedBox(
                                        width:
                                            380, // ← You can adjust width without affecting height
                                        child: AvailableMatchCard(match: match),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    bool selected = false,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (selected ? colorScheme.primary : Colors.grey[200]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? (selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
