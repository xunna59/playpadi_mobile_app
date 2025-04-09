import 'package:flutter_riverpod/flutter_riverpod.dart';

final formControllerProvider = StateNotifierProvider<FormController, FormState>(
  (ref) => FormController(),
);

class FormState {
  final int currentStep;
  final int totalPoints;
  final String? selectedPadelExperience;
  final String? selectedLawnTennisExperience;

  FormState({
    required this.currentStep,
    required this.totalPoints,
    required this.selectedPadelExperience,
    required this.selectedLawnTennisExperience,
  });

  FormState copyWith({
    int? currentStep,
    int? totalPoints,
    String? selectedPadelExperience,
    String? selectedLawnTennisExperience,
  }) {
    return FormState(
      currentStep: currentStep ?? this.currentStep,
      totalPoints: totalPoints ?? this.totalPoints,
      selectedPadelExperience:
          selectedPadelExperience ?? this.selectedPadelExperience,
      selectedLawnTennisExperience:
          selectedLawnTennisExperience ?? this.selectedLawnTennisExperience,
    );
  }
}

class FormController extends StateNotifier<FormState> {
  FormController()
    : super(
        FormState(
          currentStep: 0,
          totalPoints: 0,
          selectedPadelExperience: null,
          selectedLawnTennisExperience: null,
        ),
      );

  final List<Map<String, dynamic>> steps = [
    {
      'question': 'What is your previous experience of padel tennis?',
      'options': [
        {'option': 'Excellent', 'points': 3},
        {'option': 'Minimal', 'points': 2},
        {'option': 'None', 'points': 1},
      ],
    },
    {
      'question': 'What is your previous experience of lawn tennis?',
      'options': [
        {'option': 'Excellent', 'points': 3},
        {'option': 'Minimal', 'points': 2},
        {'option': 'None', 'points': 1},
      ],
    },
    {
      'question': 'Have you played any other racquet sports?',
      'options': [
        {'option': 'Yes', 'points': 3},
        {'option': 'No', 'points': 0},
      ],
    },
    {
      'question': 'Would you be interested in playing doubles?',
      'options': [
        {'option': 'Yes', 'points': 2},
        {'option': 'No', 'points': 1},
      ],
    },
  ];

  void goToNextStep(String? selectedValue) {
    if (selectedValue != null) {
      final currentStepData = steps[state.currentStep];
      final selectedOption = currentStepData['options']?.firstWhere(
        (option) => option['option'] == selectedValue,
      );

      if (selectedOption != null) {
        // Add the points to the total
        state = state.copyWith(
          totalPoints: state.totalPoints + (selectedOption['points'] as int),
        );
      }
    }

    if (state.currentStep < steps.length - 1) {
      // Move to the next step
      state = state.copyWith(currentStep: state.currentStep + 1);
    } else {
      // Form completion logic
      print('Form Completed! Total Points: ${state.totalPoints}');
    }
  }

  void setSelectedOption(String value, int stepIndex) {
    if (stepIndex == 0) {
      state = state.copyWith(selectedPadelExperience: value);
    } else if (stepIndex == 1) {
      state = state.copyWith(selectedLawnTennisExperience: value);
    }
  }
}
