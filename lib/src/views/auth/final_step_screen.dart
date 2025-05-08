import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/steps_controller.dart';
import '../../widgets/question_form.dart';

class FinalStepScreen extends ConsumerWidget {
  const FinalStepScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formControllerProvider);
    final controller = ref.read(formControllerProvider.notifier);
    final stepData = controller.steps[formState.currentStep];
    final primary = Theme.of(context).colorScheme.primary;

    // Determine which value is selected for this step
    String? selectedValue;
    switch (formState.currentStep) {
      case 0:
        selectedValue = formState.selectedPadelExperience;
        break;
      case 1:
        selectedValue = formState.selectedSnookerExperience;
        break;
      case 2:
        selectedValue = formState.selectedDartsExperience;
        break;
      case 3:
        selectedValue = formState.selectedOtherRacquetExperience;
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (formState.currentStep == 0) {
              Navigator.pop(context); // triggers autoDispose
            } else {
              controller.goToPreviousStep();
            }
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Full-screen background image
          Image.asset(
            'assets/background/onboarding_background.png',
            fit: BoxFit.cover,
          ),

          // 2) Semi-transparent dark overlay
          Container(color: Colors.black54),

          // 3) Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value:
                        (formState.currentStep + 1) / controller.steps.length,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    color: primary,
                  ),
                  const SizedBox(height: 16),

                  // Question form for this step
                  QuestionForm(
                    question: stepData['question'] as String,
                    options:
                        (stepData['options'] as List)
                            .map((o) => o['option'] as String)
                            .toList(),
                    selectedValue: selectedValue,
                    onValueChanged: (value) {
                      if (value == null) return;
                      controller.setSelectedOption(
                        value,
                        formState.currentStep,
                      );
                      controller.goToNextStep(value, context);
                    },
                    onNextStep: () {}, // unused here
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
