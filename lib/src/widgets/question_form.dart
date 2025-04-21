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
          // const LinearProgressIndicator(
          //   value: 0.8,
          //   backgroundColor: Colors.grey,
          //   color: Colors.orange,
          // ),
          const SizedBox(height: 16),

          // Header
          Text(
            'Final step',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Establish your initial grade level by answering the following questions.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Text(
                  question,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                for (String option in options)
                  RadioListTile<String>(
                    title: Text(option, style: TextStyle(color: Colors.black)),
                    value: option,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      onValueChanged(value);
                      onNextStep();
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
