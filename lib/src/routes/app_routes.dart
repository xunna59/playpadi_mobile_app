import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/home_screen.dart';
import '../views/splash_screen.dart';
import '../views/auth/auth_screen.dart';
import '../views/auth/register_step_one.dart';
import '../views/auth/register_step_two.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String registerStepOne = '/registerStepOne';
  static const String registerStepTwo = '/registerStepTwo';
  static const String login = '/login';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case registerStepOne:
        return MaterialPageRoute(builder: (_) => const RegisterStepOne());
      case registerStepTwo:
        return MaterialPageRoute(builder: (_) => const RegisterStepTwo());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
