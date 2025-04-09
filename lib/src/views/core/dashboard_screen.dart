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
      // Wrap the body in a SingleChildScrollView to make it scrollable
      body: SingleChildScrollView(
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
              elevation: 2,
              color: colorScheme.secondary,
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
            const Text(
              'Play your perfect match',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Using MatchCard for the 'Play your perfect match' section
            Column(
              children: [
                MatchCard(
                  icon: Icons.search,
                  title: 'Book a court',
                  subtitle: 'If you already know who you are playing with',
                  imageUrl:
                      'https://beaconathletics.com/wp-content/uploads/2015/02/21September_BeaconAthletics_1836.jpg?x45230', // Replace with actual image URL
                  onTap: () {
                    // Navigate to book court
                  },
                ),
                const SizedBox(height: 16),
                MatchCard(
                  icon: Icons.group,
                  title: 'Play an open match',
                  subtitle: 'If you are looking for players at your level',
                  imageUrl:
                      'https://beaconathletics.com/wp-content/uploads/2015/02/21September_BeaconAthletics_1836.jpg?x45230', // Replace with actual image URL
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
