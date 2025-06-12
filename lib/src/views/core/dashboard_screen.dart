import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../playpadi_library.dart';
import '../../controllers/user_Profile_controller.dart';
import '../../core/constants.dart';
import '../../models/user_profile_model.dart';
import '../../routes/app_routes.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home_tab_screen.dart';
import 'profile_tab_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final controller = UserProfileController();
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    loadUserProfile();
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      print("✅ Notification permission granted.");
    } else if (status.isDenied) {
      print("❌ Notification permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Notification permanently denied. Opening app settings...");
      await openAppSettings();
    }
  }

  Future<void> loadUserProfile() async {
    try {
      if (APIClient.instance.isAuthorized != true) {
        Navigator.pushReplacementNamed(context, '/auth');
      }

      final profile = await controller.fetchUserProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;

        if (_profile!.points == '0.00') {
          Navigator.pushNamed(context, AppRoutes.finalSteps);
        }
      });

      print(_profile!.preferences);
    } on ServerErrorException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was a server error. Please try again later.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load profile. Please try again later.'),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     systemNavigationBarColor: Color.fromRGBO(10, 8, 18, 1),
    //     systemNavigationBarIconBrightness: Brightness.light,
    //     statusBarColor: Color.fromRGBO(10, 8, 18, 1),
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );
    final colorScheme = Theme.of(context).colorScheme;

    final tabs = <Widget>[
      RefreshIndicator(onRefresh: loadUserProfile, child: const HomeTab()),
      RefreshIndicator(onRefresh: loadUserProfile, child: const ProfileTab()),
    ];

    return Scaffold(
      appBar:
          _selectedIndex == 0
              ? AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  'Hi ${_profile?.firstName ?? ''} ✌️',
                  style: TextStyle(fontSize: 19),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      _profile?.displayPicture != null
                          ? CircleAvatar(
                            radius: 30,
                            backgroundColor: colorScheme.tertiary,
                            backgroundImage: NetworkImage(
                              '${display_picture}${_profile!.displayPicture!}',
                            ),
                          )
                          : CircleAvatar(
                            radius: 30,
                            backgroundColor: colorScheme.tertiary,
                            backgroundImage: const AssetImage(
                              'assets/images/user.png',
                            ),
                          ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profileScreen);
                    },
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.refresh),
                  //   tooltip: 'Reload Profile',
                  //   onPressed: loadUserProfile,
                  // ),
                ],
              )
              : AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: const Text('Profile'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profileScreen);
                    },
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.refresh),
                  //   tooltip: 'Reload Profile',
                  //   onPressed: loadUserProfile,
                  // ),
                ],
              ),
      body: IndexedStack(index: _selectedIndex, children: tabs),
      floatingActionButton:
          _selectedIndex == 0
              ? SpeedDial(
                icon: Icons.add,
                activeIcon: Icons.close,
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                spacing: 10,
                spaceBetweenChildren: 8,
                children: [
                  SpeedDialChild(
                    labelWidget: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Booking',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.playOpenMatches);
                    },
                  ),
                  SpeedDialChild(
                    labelWidget: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Match', style: TextStyle(color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.sports_tennis, color: Colors.white),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.eventCenter);
                    },
                  ),
                ],
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        backgroundColor: colorScheme.secondary,
        iconSize: 28.0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(height: 1.1),
        unselectedLabelStyle: const TextStyle(height: 1.1),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
