import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tunde Bakare',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Standard account',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Share Profile Button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_outlined),
              label: const Text('Share profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Your account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            _buildAccountCard([
              _buildListTile(
                Icons.person_outline,
                'Edit profile',
                'Name, email, phone, location, gender, ...',
              ),
              _buildListTile(
                Icons.sports_tennis,
                'Your activity',
                'Matches, classes, competitions, group, ...',
              ),
              _buildListTile(
                Icons.credit_card,
                'Your payments',
                'Payment methods, transactions, club, ...',
              ),
              _buildListTile(
                Icons.settings,
                'Settings',
                'Configure privacy, notifications, security, ...',
              ),
            ]),

            const SizedBox(height: 24),
            const Text(
              'Support',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAccountCard([
              _buildListTile(Icons.help_outline, 'Help', null),
              _buildListTile(
                Icons.question_mark_outlined,
                'How PlayPadi works',
                null,
              ),
            ]),

            const SizedBox(height: 24),
            const Text(
              'Legal information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAccountCard([
              _buildListTile(Icons.article_outlined, 'Terms of use', null),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  static Widget _buildListTile(IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: const TextStyle(fontSize: 12))
              : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
