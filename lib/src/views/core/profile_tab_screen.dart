import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../playpadi_library.dart';
import '../../core/activity_overlay.dart';
import '../../core/constants.dart';
import '../../models/user_profile_model.dart';
import '../../controllers/user_Profile_controller.dart';
import '../../routes/app_routes.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final client = APIClient();

  UserProfile? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await UserProfileController().fetchUserProfile();
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    final visibleChars = username.length >= 2 ? 2 : 1;
    final maskedUsername =
        username.substring(0, visibleChars) +
        '*' * (username.length - visibleChars);

    return '$maskedUsername@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    final profile = _profile;
    if (profile == null) {
      return const Center(child: Text('No profile found'));
    }

    String bestHand = profile.preferences['best_hand'] ?? 'Not Set';
    String courtPosition = profile.preferences['court_position'] ?? 'Not Set';
    String matchType = profile.preferences['match_type'] ?? 'Not Set';
    String playTime = profile.preferences['play_time'] ?? 'Not Set';

    // Example chart data
    final spots = <FlSpot>[FlSpot(1, 1), FlSpot(6, 2), FlSpot(12, 5)];

    double points = double.tryParse(profile.points) ?? 0;

    String getLevel(double points) {
      if (points <= 1.5) return 'Beginner';
      if (points <= 3.5) return 'Amateur';
      if (points <= 5.0) return 'Pro';
      return 'Expert';
    }

    Color getLevelColor(double points) {
      if (points <= 1.5) return Colors.red;
      if (points <= 3.5) return Colors.orange;
      if (points <= 5.0) return Colors.green;
      return Colors.blue;
    }

    void _processResendEmailVerification() async {
      Map<String, String> data = {'email': profile.email};

      LoadingOverlay.show(context);

      try {
        await client.resendEmailVerification(data, () {
          //  debugPrint('Login successful');

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Verification Email sent. Please check your inbox',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        });
      } on NetworkErrorException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on InvalidResponseException {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An Error Occured, Try Again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on ServerErrorException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        LoadingOverlay.hide();
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton.icon(
            //     onPressed: () {},
            //     icon: const Icon(Icons.refresh),
            //     label: const Text('Resend Verification Email'),
            //     style: OutlinedButton.styleFrom(
            //       side: const BorderSide(color: Color.fromRGBO(199, 3, 125, 1)),
            //       foregroundColor: const Color.fromRGBO(199, 3, 125, 1),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       textStyle: const TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.tertiary,
                  backgroundImage:
                      profile.displayPicture != null
                          ? NetworkImage(
                            '${display_picture}${_profile!.displayPicture!}',
                          )
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.firstName} ${profile.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      profile.email_verified == true
                          ? Row(
                            children: [
                              Text(
                                maskEmail(profile.email),
                                style: TextStyle(color: colorScheme.primary),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: Colors.lightGreen,
                                size: 18,
                              ),
                            ],
                          )
                          : Row(
                            children: [
                              Text(
                                maskEmail(profile.email),
                                style: TextStyle(color: colorScheme.primary),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: () {
                                  _processResendEmailVerification();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Color.fromRGBO(199, 3, 125, 1),
                                    width: 1,
                                  ), // outline color
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Resend",
                                  style: TextStyle(
                                    color: Color.fromRGBO(199, 3, 125, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Total Matches', profile.total_matches_played),
              ],
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.editProfileScreen);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Edit profile',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/background/profile_cover.jpg',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      'Level ${profile.points}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (points <= 5.0)
                    Positioned(
                      left: 16,
                      bottom: 12,
                      child: Chip(
                        label: Text(getLevel(points)),
                        backgroundColor: getLevelColor(points),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Level progression',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      color: const Color.fromRGBO(199, 3, 125, 1),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Player preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              icon: Icons.pan_tool,
              color: Colors.orange,
              title: 'Best hand',
              subtitle: bestHand,
              scheme: colorScheme,
            ),
            _buildPreferenceCard(
              icon: Icons.place,
              color: Colors.redAccent,
              title: 'Court position',
              subtitle: courtPosition,
              scheme: colorScheme,
            ),
            _buildPreferenceCard(
              icon: Icons.emoji_events,
              color: Colors.amber,
              title: 'Match type',
              subtitle: matchType,
              scheme: colorScheme,
            ),
            _buildPreferenceCard(
              icon: Icons.access_time,
              color: Colors.blueGrey,
              title: 'Preferred time to play',
              subtitle: playTime,
              scheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPreferenceCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required ColorScheme scheme,
  }) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 10)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
