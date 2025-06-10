import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromRGBO(10, 8, 18, 1),
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Color.fromRGBO(10, 8, 18, 1),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 8, 18, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/Icon - Main.png', width: 120),
            SizedBox(height: 25),
            Text(
              'PlayPadi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
