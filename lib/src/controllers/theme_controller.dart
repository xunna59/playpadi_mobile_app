import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>(
      (ref) => ThemeController(),
    );

class ThemeController extends StateNotifier<ThemeMode>
    with WidgetsBindingObserver {
  ThemeController() : super(ThemeMode.system) {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  // Load theme initially
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode');

    if (themeString == 'light') {
      state = ThemeMode.light;
    } else if (themeString == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  // Toggle Theme manually
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString('themeMode', 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString('themeMode', 'light');
    }
  }

  // Listen for system brightness changes clearly
  @override
  void didChangePlatformBrightness() {
    if (state == ThemeMode.system) {
      state = ThemeMode.system; // Trigger rebuild on system change
    }
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
