import 'package:flutter/material.dart';
import 'package:playpadi/src/models/event_center_model.dart';
import 'package:playpadi/src/views/core/academy/academy_screen.dart';
import '../views/auth/completed_screen.dart';
import '../views/auth/final_step_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/core/bookings/available_matches_screen.dart';
import '../views/core/bookings/center_details_screen.dart';
import '../views/core/bookings/event_centers_screen.dart';
import '../views/core/notifications.dart';
import '../views/core/settings/player_preferences.dart';
import '../views/core/settings/profile_screen.dart';
import '../views/home_screen.dart';
import '../views/splash_screen.dart';
import '../views/auth/auth_screen.dart';
import '../views/auth/register_step_one.dart';
import '../views/auth/register_step_two.dart';
import '../views/core/dashboard_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String registerStepOne = '/registerStepOne';
  static const String registerStepTwo = '/registerStepTwo';
  static const String finalSteps = '/finalSteps';
  static const String completedSteps = '/completedSteps';

  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static const String eventCenter = '/eventCenter';
  static const String eventCenterDetails = '/eventCenterDetails';
  static const String playOpenMatches = '/playOpenMatches';
  static const String notifications = '/notifications';
  static const String playerPrefernces = '/playerPrefernces';
  static const String profileScreen = '/profile_screen';
  static const String academyScreen = '/academy_screen';

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
        final validEmail = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RegisterStepTwo(validEmail: validEmail),
        );
      case finalSteps:
        return MaterialPageRoute(builder: (_) => const FinalStepScreen());
      case completedSteps:
        return MaterialPageRoute(builder: (_) => const CompletedScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case academyScreen:
        return MaterialPageRoute(builder: (_) => const AcademyScreen());

      case playerPrefernces:
        return MaterialPageRoute(
          builder: (_) => const PlayerPreferenceScreen(),
        );

      case profileScreen:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // From bottom
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case playOpenMatches:
        return MaterialPageRoute(
          builder: (_) => const AvailableMatchesScreen(),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case eventCenter:
        return MaterialPageRoute(builder: (_) => const EventCentersScreen());
      case eventCenterDetails:
        final eventCenter = settings.arguments as EventCenter?;
        if (eventCenter == null) {
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text('No Event Center Data Provided')),
                ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => EventCenterDetailsScreen(eventCenter: eventCenter),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
