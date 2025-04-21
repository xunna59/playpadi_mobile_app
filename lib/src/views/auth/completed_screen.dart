import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/steps_controller.dart';
import '../../widgets/primary_button.dart';

class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formControllerProvider);
    final formController = ref.read(formControllerProvider.notifier);

    final totalPoints = formState.totalPoints;
    final totalPossiblePoints =
        12; // Adjust this value according to your total possible points

    // Calculate the percentage of progress
    double progress = totalPoints / totalPossiblePoints;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go to previous screen
          },
        ),
        actions: const [Icon(Icons.notifications, color: Colors.black)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),

            // Circular Progress Indicator
            Center(
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.orange),
              ),
            ),
            const SizedBox(height: 24),

            // Points Display
            Center(
              child: Text(
                '$totalPoints', // Display total points
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Text Under Total Points
            Center(
              child: Text(
                'You are ready to play',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Center(
              child: Text(
                'You can start playing games to increase your grade.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            const Spacer(),

            // Start Playing Button
            PrimaryButton(
              text: 'Start Playing',
              onPressed: () {
                // Navigator.pushNamed(context, AppRoutes.dashboard);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
