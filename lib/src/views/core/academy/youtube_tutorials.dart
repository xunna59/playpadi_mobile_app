import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/tutorial_provider.dart';
import '../../../widgets/tutorials_card.dart';

class YouTubeTutorialsTab extends ConsumerWidget {
  const YouTubeTutorialsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTutorials = ref.watch(tutorialsProvider);

    return asyncTutorials.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No tutorials found.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(tutorialsProvider); // This will refetch the data
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: list.length,
            itemBuilder: (ctx, i) => TutorialCard(tutorial: list[i]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading tutorials:\n$err')),
    );
  }
}
