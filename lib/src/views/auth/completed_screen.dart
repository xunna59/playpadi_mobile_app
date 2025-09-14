import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/steps_controller.dart';
import '../../controllers/user_Profile_controller.dart';
import '../../core/activity_overlay.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formControllerProvider);
    final totalPoints = formState.totalPoints;
    const double totalPossiblePoints = 5.0;
    final progress = (totalPoints / totalPossiblePoints).clamp(0.0, 1.0);

    // final colorScheme = Theme.of(context).colorScheme;

    final controller = UserProfileController();

    void _updateFCMToken(updates) async {
      await controller.updateFCMToken(updates);
    }

    void _saveProfile() async {
      final updates = {'points': totalPoints};
      LoadingOverlay.show(context);
      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        final update_fcm = {'fcm_token': fcmToken};

        if (fcmToken != null) {
          _updateFCMToken(update_fcm);
        }

        await controller.updateUserProfile(updates);
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } catch (e) {
        // show error to the user…
      } finally {
        LoadingOverlay.hide();
      }
    }

    const double circleSize = 120.0;
    // shrink factor (80% of outer)
    const double innerFactor = 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16),
        //     child: Icon(Icons.notifications),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),

            // 1) Circle + points inside
            Center(
              child: SizedBox(
                width: circleSize,
                height: circleSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // shrink the circle itself
                    SizedBox(
                      width: circleSize * innerFactor,
                      height: circleSize * innerFactor,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation(
                          Color.fromRGBO(199, 3, 125, 1),
                        ),
                      ),
                    ),
                    Text(
                      totalPoints.toStringAsFixed(
                        totalPoints.truncateToDouble() == totalPoints ? 0 : 1,
                      ),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2) Keep showing your "You are ready to play" text
            Center(
              child: Text(
                'You are ready to play',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'You can start playing games to increase your grade.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  //   color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),

            const Spacer(),

            PrimaryButton(
              text: 'Start Playing',
              onPressed: () {
                _saveProfile();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
