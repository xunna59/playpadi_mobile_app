import 'package:flutter/material.dart';
import '../../widgets/match_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi Tunde ✌️'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Profile action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // To do section
            const Text(
              'To do...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit your player preferences'),
                subtitle: const Text(
                  'Best hand, court side, match type, Preferred time to play',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to preferences screen
                },
              ),
            ),
            const SizedBox(height: 24),

            // "Play your perfect match" section
            const Text(
              'Play your perfect match',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MatchCard(
                  icon: Icons.search,
                  title: 'Book a court',
                  subtitle: 'If you already know who you are playing with',
                  imageUrl:
                      'https://example.com/your-image.jpg', // Replace with actual URL or asset
                  onTap: () {
                    // Navigate to book court
                  },
                ),
                MatchCard(
                  icon: Icons.group,
                  title: 'Play an open match',
                  subtitle: 'If you are looking for players at your level',
                  imageUrl:
                      'https://example.com/your-image.jpg', // Replace with actual URL or asset
                  onTap: () {
                    // Navigate to open match
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
