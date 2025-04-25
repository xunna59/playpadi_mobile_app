import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home_tab_screen.dart';
import 'profile_tab_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabs = <Widget>[const HomeTab(), const ProfileTab()];

    return Scaffold(
      appBar:
          _selectedIndex == 0
              ? AppBar(
                title: const Text('Hi Tunde ✌️'),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.add, color: Colors.black),
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
                ],
              )
              : AppBar(
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
                    onTap: () => print('Booking tapped'),
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
                    onTap: () => print('Match tapped'),
                  ),
                ],
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
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
