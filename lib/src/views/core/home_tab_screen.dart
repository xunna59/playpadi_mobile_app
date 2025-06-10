import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';
import '../../widgets/match_card.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'To do...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/icons/paddle_bat.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                  title: const Text(
                    'Edit your player preferences',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Best hand, court side, match type, preferred time to play',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.playerPrefernces,
                      //   arguments: UserProfile,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Play your perfect match',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              MatchCard(
                icon: Icons.search,
                title: 'Book a Court',
                subtitle:
                    'Perfect when you already have your playing partner(s)',
                imageUrl: 'assets/background/book_court.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.eventCenter);
                },
              ),
              const SizedBox(height: 16),
              MatchCard(
                icon: Icons.group,
                title: 'Play an Open Match',
                subtitle: 'Find and play with others at your skill level',
                imageUrl: 'assets/background/open_match.png',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.playOpenMatches);
                  //  ref.invalidate(matchesFutureProvider);
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Adjust the radius as needed
                    ),
                    child: IconButton(
                      icon: Icon(Icons.school, color: Colors.white),
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.academyScreen);
                      },
                    ),
                  ),

                  Text('Classes'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
