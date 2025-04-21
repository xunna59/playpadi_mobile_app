import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/steps_controller.dart';
import '../../widgets/question_form.dart';
// import '../../screens/final_score_screen.dart'; // Import the FinalScoreScreen

class FinalStepScreen extends ConsumerWidget {
  const FinalStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formControllerProvider);
    final formController = ref.read(formControllerProvider.notifier);

    final currentStepData = formController.steps[formState.currentStep];
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // ensure visibility
          onPressed: () => formController.goToPreviousStep(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background/onboarding_background.png',
            ), // your image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: (formState.currentStep + 1) / 4,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),

                // Question Form
                QuestionForm(
                  question: currentStepData['question'],
                  options:
                      currentStepData['options']!
                          .map<String>((option) => option['option'] as String)
                          .toList(),
                  selectedValue:
                      formState.currentStep == 0
                          ? formState.selectedPadelExperience
                          : formState.currentStep == 1
                          ? formState.selectedLawnTennisExperience
                          : null,
                  onValueChanged: (value) {
                    if (value != null) {
                      formController.setSelectedOption(
                        value,
                        formState.currentStep,
                      );
                      formController.goToNextStep(
                        value,
                        context,
                      ); // Pass context to trigger navigation
                    }
                  },
                  onNextStep:
                      () => formController.goToNextStep(
                        formState.currentStep == 0
                            ? formState.selectedPadelExperience
                            : formState.selectedLawnTennisExperience,
                        context, // Pass context to navigate
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
