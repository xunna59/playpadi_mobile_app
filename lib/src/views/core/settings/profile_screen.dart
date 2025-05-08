import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../playpadi_library.dart';
import '../../../controllers/user_Profile_controller.dart';
import '../../../models/user_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = UserProfileController();
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final profile = await controller.fetchUserProfile();
      setState(() {
        _profile = profile;
      });
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('There was a server error. Please try again later.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                _profile?.displayPicture != null
                    ? CircleAvatar(
                      radius: 30,
                      backgroundImage: MemoryImage(
                        base64Decode(_profile!.displayPicture!.split(',').last),
                      ),
                    )
                    : const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_profile?.firstName ?? ''} ${_profile?.lastName ?? ''}' ??
                          'John Doe',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _profile?.accountType ?? 'Standard account',
                      style: const TextStyle(color: Colors.grey),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  static Widget _buildListTile(IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: Icon(icon),
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
