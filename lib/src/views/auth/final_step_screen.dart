import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/steps_controller.dart';
import '../../widgets/question_form.dart';

class FinalStepScreen extends ConsumerWidget {
  const FinalStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formControllerProvider);
    final formController = ref.read(formControllerProvider.notifier);

    // Access the steps list from the controller
    final currentStepData = formController.steps[formState.currentStep];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [Icon(Icons.notifications, color: Colors.black)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (formState.currentStep + 1) / 4, // Since there are 4 steps
              backgroundColor: Colors.grey,
              color: Colors.orange,
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
                }
              },
              onNextStep:
                  () => formController.goToNextStep(
                    formState.currentStep == 0
                        ? formState.selectedPadelExperience
                        : formState.selectedLawnTennisExperience,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
