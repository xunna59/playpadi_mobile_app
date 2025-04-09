import 'package:flutter/material.dart';

class QuestionForm extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onValueChanged;
  final VoidCallback onNextStep;

  const QuestionForm({
    super.key,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onValueChanged,
    required this.onNextStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar (80% completed)
          const LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.grey,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),

          // Header
          Text(
            'Final step',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Establish your initial grade level by answering the following questions.',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Question
          Text(
            question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Radio buttons for options
          for (String option in options)
            RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedValue,
              onChanged: onValueChanged,
            ),
          const SizedBox(height: 24),

          // Next Step button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onNextStep,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
