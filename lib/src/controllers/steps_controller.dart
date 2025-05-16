// controllers/steps_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/app_routes.dart';

// autoDispose so state vanishes when you pop
final formControllerProvider =
    StateNotifierProvider.autoDispose<FormController, FormState>(
      (ref) => FormController(),
    );

class FormState {
  final int currentStep;
  final double totalPoints; // <-- now a double

  final String? selectedPadelExperience;
  final String? selectedSnookerExperience;
  final String? selectedDartsExperience;
  final String? selectedOtherRacquetExperience;

  FormState({
    required this.currentStep,
    required this.totalPoints,
    this.selectedPadelExperience,
    this.selectedSnookerExperience,
    this.selectedDartsExperience,
    this.selectedOtherRacquetExperience,
  });

  FormState copyWith({
    int? currentStep,
    double? totalPoints, // <-- updated
    String? selectedPadelExperience,
    String? selectedSnookerExperience,
    String? selectedDartsExperience,
    String? selectedOtherRacquetExperience,
  }) {
    return FormState(
      currentStep: currentStep ?? this.currentStep,
      totalPoints: totalPoints ?? this.totalPoints,
      selectedPadelExperience:
          selectedPadelExperience ?? this.selectedPadelExperience,
      selectedSnookerExperience:
          selectedSnookerExperience ?? this.selectedSnookerExperience,
      selectedDartsExperience:
          selectedDartsExperience ?? this.selectedDartsExperience,
      selectedOtherRacquetExperience:
          selectedOtherRacquetExperience ?? this.selectedOtherRacquetExperience,
    );
  }
}

class FormController extends StateNotifier<FormState> {
  FormController()
    : super(
        FormState(
          currentStep: 0,
          totalPoints: 0.0, // <-- initialize as double
        ),
      );

  final List<Map<String, dynamic>> steps = [
    {
      'question': 'What is your previous experience of padel tennis?',
      'options': [
        {'option': 'Excellent', 'points': 2.0},
        {'option': 'Minimal', 'points': 1.0},
        {'option': 'None', 'points': 0.1},
      ],
    },
    {
      'question': 'What is your previous experience of Snooker?',
      'options': [
        {'option': 'Excellent', 'points': 1.0},
        {'option': 'Minimal', 'points': 0.4},
        {'option': 'None', 'points': 0.1},
      ],
    },
    {
      'question': 'What is your previous experience of Darts?',
      'options': [
        {'option': 'Excellent', 'points': 1.0},
        {'option': 'Minimal', 'points': 0.4},
        {'option': 'None', 'points': 0.1},
      ],
    },
    {
      'question': 'Have you played any other racquet sports?',
      'options': [
        {'option': 'Yes', 'points': 1.0},
        {'option': 'No', 'points': 0.1},
      ],
    },
  ];

  void goToPreviousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToNextStep(String? selectedValue, BuildContext context) {
    if (selectedValue != null) {
      final opt = (steps[state.currentStep]['options'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((o) => o['option'] == selectedValue);

      // add double points
      final pts = (opt['points'] as num).toDouble();
      state = state.copyWith(totalPoints: state.totalPoints + pts);
    }

    if (state.currentStep < steps.length - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.completedSteps);
    }
  }

  void setSelectedOption(String value, int stepIndex) {
    switch (stepIndex) {
      case 0:
        state = state.copyWith(selectedPadelExperience: value);
        break;
      case 1:
        state = state.copyWith(selectedSnookerExperience: value);
        break;
      case 2:
        state = state.copyWith(selectedDartsExperience: value);
        break;
      case 3:
        state = state.copyWith(selectedOtherRacquetExperience: value);
        break;
    }
  }
}
