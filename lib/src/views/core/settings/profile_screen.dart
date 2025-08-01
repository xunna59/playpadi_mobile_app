import 'dart:convert';
import '../../../../src/core/capitalization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../playpadi_library.dart';
import '../../../controllers/theme_controller.dart';
import '../../../controllers/user_Profile_controller.dart';
import '../../../core/constants.dart';
import '../../../models/user_profile_model.dart';
import '../../../providers/user_provider.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final controller = UserProfileController();
  UserProfile? _profile;
  final APIClient client = APIClient();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // try {
    //   final profile = await controller.fetchUserProfile();
    //   if (!mounted) return;
    //   setState(() => _profile = profile);
    // } on ServerErrorException {
    //   if (!mounted) return;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'There was a server error. Please try again later.',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   );
    // } catch (_) {
    //   if (!mounted) return;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Failed to load profile. Please try again later.',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // watch theme provider
    final themeMode = ref.watch(themeControllerProvider);
    final themeNotifier = ref.read(themeControllerProvider.notifier);
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final displayImage = ref.watch(displayImageProvider);
    final accountType = ref.watch(accountTypeProvider);

    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  displayImage != null
                      ? CircleAvatar(
                        radius: 30,
                        backgroundColor: colorScheme.tertiary,
                        backgroundImage: NetworkImage(
                          '${display_picture}${displayImage}',
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
                        '${firstName} ${lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        accountType?.capitalizeFirst() ?? 'Standard',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Share Profile Button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Add share logic
                },
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
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.editProfileScreen,
                      ),
                ),
                _buildListTile(
                  Icons.sports_tennis,
                  'Your activity',
                  'Login Activity, Matches, Classes, Membership, ...',
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.activityScreen,
                      ),
                ),
                _buildListTile(
                  Icons.credit_card,
                  'Your payments',
                  'Payment methods, transactions, club, ...',
                  onTap:
                      () =>
                          Navigator.pushNamed(context, AppRoutes.paymentScreen),
                ),
              ]),

              const SizedBox(height: 24),
              const Text(
                'Support',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildAccountCard([
                _buildListTile(
                  Icons.help_outline,
                  'Help',
                  null,
                  onTap:
                      () => Navigator.pushNamed(context, AppRoutes.helpScreen),
                ),
                _buildListTile(
                  Icons.question_mark_outlined,
                  'How PlayPadi works',
                  null,
                  onTap:
                      () => Navigator.pushNamed(context, AppRoutes.faqScreen),
                ),
              ]),

              const SizedBox(height: 24),
              const Text(
                'Legal information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildAccountCard([
                _buildListTile(
                  Icons.article_outlined,
                  'Terms of use',
                  null,
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.termsOfUseScreen,
                      ),
                ),
                _buildListTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  null,
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.privacyPolicyScreen,
                      ),
                ),
              ]),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        final colorScheme = Theme.of(context).colorScheme;

                        return AlertDialog(
                          backgroundColor: colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Confirm Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                          actionsPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.onSurface,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () {
                                client.logout(); // Call logout from ApiClient
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.auth,
                                );
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48), // Full-width button
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  static Widget _buildListTile(
    IconData icon,
    String title,
    String? subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: const TextStyle(fontSize: 12))
              : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
