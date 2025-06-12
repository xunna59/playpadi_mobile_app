import 'package:flutter/material.dart';

import 'primary_button.dart';

Future<String?> showSelectSportModal(BuildContext context) async {
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
            child: Wrap(
              children: [
                const Text(
                  "What sport do you want to play?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Options
                _SportOption(
                  title: "Padel",
                  selected: selected,
                  onSelect: (value) => setState(() => selected = value),
                ),
                _SportOption(
                  title: "Snooker",
                  selected: selected,
                  onSelect: (value) => setState(() => selected = value),
                ),
                _SportOption(
                  title: "Darts",
                  selected: selected,
                  onSelect: (value) => setState(() => selected = value),
                ),

                // _SportOption(
                //   title: "Chess",
                //   selected: selected,
                //   onSelect: (value) => setState(() => selected = value),
                // ),
                const SizedBox(height: 16),

                // Select Button
                PrimaryButton(
                  text: 'Select Sport',
                  onPressed: () {
                    Navigator.pop(context, selected);
                  },
                ),
                const SizedBox(height: 24),
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
