import 'dart:async';
import 'package:flutter/material.dart';

import '../../playpadi_library.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await APIClient.instance.loadToken(); // Load token from SharedPreferences

    Timer(const Duration(seconds: 2), () {
      if (APIClient.instance.isAuthorized) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 8, 18, 1),
      body: Center(
        child: Image.asset('assets/logo/Icon - Main.png', width: 120),
      ),
    );
  }
}
