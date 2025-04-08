import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/controllers/theme_controller.dart';
import 'src/core/app_theme.dart';
import 'src/views/auth/auth_screen.dart';
import 'src/views/auth/register_step_one.dart';
import 'src/views/auth/register_step_two.dart';
import 'src/views/auth/login_screen.dart';

import 'src/views/home_screen.dart';
import 'src/views/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp(
      //   title: 'PlayPadi',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/registerStepOne': (context) => const RegisterStepOne(),
        '/registerStepTwo': (context) => const RegisterStepTwo(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
