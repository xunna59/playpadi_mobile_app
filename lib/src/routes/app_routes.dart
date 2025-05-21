import 'package:flutter/material.dart';

import '../models/class_model.dart';
import '../models/event_center_model.dart';
import '../models/match_model.dart';
import '../models/user_profile_model.dart';
import '../views/auth/completed_screen.dart';
import '../views/auth/final_step_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/core/academy/academy_screen.dart';
import '../views/core/academy/class_details/class_details_screen.dart';
import '../views/core/bookings/available_matches_screen.dart';
import '../views/core/bookings/center_details_screen.dart';
import '../views/core/bookings/confirm_booking_screen.dart';
import '../views/core/bookings/event_centers_screen.dart';
import '../views/core/bookings/match_details_screen.dart';
import '../views/core/notifications.dart';
import '../views/core/settings/help/faq_screen.dart';
import '../views/core/settings/help/help_screen.dart';
import '../views/core/settings/legal/privacy_policy_screen.dart';
import '../views/core/settings/legal/terms_screen.dart';
import '../views/core/settings/player_preferences.dart';
import '../views/core/settings/profile/edit_profile_screen.dart';
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
  static const String matchDetailsScreen = 'matchDetailsScreen';
  static const String classDetailsScreen = 'classDetailsScreen';
  static const String confirmBookingScreen = 'confirmBookingScreen';
  static const String helpScreen = 'helpScreen';
  static const String termsOfUseScreen = 'termsOfUseScreen';
  static const String privacyPolicyScreen = 'privacyPolicyScreen';
  static const String faqScreen = 'faqScreen';

  static const String editProfileScreen = 'editProfileScreen';

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

      case confirmBookingScreen:
        return MaterialPageRoute(builder: (_) => const ConfirmBookingScreen());

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
      case editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case playOpenMatches:
        return MaterialPageRoute(
          builder: (_) => const AvailableMatchesScreen(),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case helpScreen:
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      case faqScreen:
        return MaterialPageRoute(builder: (_) => FaqScreen());

      case termsOfUseScreen:
        return MaterialPageRoute(builder: (_) => const TermsOfUseScreen());

      case privacyPolicyScreen:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

      case eventCenter:
        return MaterialPageRoute(builder: (_) => const EventCentersScreen());

      case eventCenterDetails:
        final eventCenter = settings.arguments as EventCenter;
        return MaterialPageRoute(
          builder: (_) => EventCenterDetailsScreen(eventCenter: eventCenter),
        );

      case playerPrefernces:
        // final user = settings.arguments as UserProfile;
        return MaterialPageRoute(builder: (_) => PlayerPreferenceScreen());

      case matchDetailsScreen:
        final match = settings.arguments as MatchModel;
        return MaterialPageRoute(
          builder: (_) => MatchDetailsScreen(match: match),
        );

      case classDetailsScreen:
        final classData = settings.arguments as ClassModel;
        return MaterialPageRoute(
          builder: (_) => ClassDetailsScreen(classData: classData),
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
