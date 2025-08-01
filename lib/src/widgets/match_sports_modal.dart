import 'package:flutter/material.dart';
import 'primary_button.dart';
import '../../src/models/event_center_model.dart';

Future<String?> showMatchSelectSportModal(
  BuildContext context, {
  required List<String> sports,
}) async {
  final colorScheme = Theme.of(context).colorScheme;
  String? selected;

  return showModalBottomSheet<String>(
    backgroundColor: colorScheme.secondary,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "What sport do you want to play?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 25),
                ...sports.map(
                  (sport) => _SportOption(
                    title: sport,
                    selected: selected,
                    onSelect: (value) => setState(() => selected = value),
                  ),
                ),
                const SizedBox(height: 26),
                PrimaryButton(
                  text: 'Select Sport',
                  onPressed: () {
                    Navigator.pop(context, selected);
                  },
                ),
                const SizedBox(height: 14),
              ],
            ),
          );
        },
      );
    },
  );
}

class _SportOption extends StatelessWidget {
  final String title;
  final String? selected;
  final Function(String) onSelect;

  const _SportOption({
    required this.title,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selected == title;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: colorScheme.primary,
      ),
      title: Text(title),
      onTap: () => onSelect(title),
    );
  }
}
