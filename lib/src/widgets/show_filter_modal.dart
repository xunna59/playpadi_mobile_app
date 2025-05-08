import 'package:flutter/material.dart';

void showFilterModal(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  // ✅ Define state variables outside the builder
  bool showUnavailable = false;
  String selectedSort = 'Relevance';
  String selectedDuration = '60 mins';
  String selectedType = 'Indoor';
  Set<String> selectedFeatures = {'Wall'};

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Widget buildFilterChips(
            List<String> options,
            String selected,
            void Function(String) onSelect,
          ) {
            return Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Ensures left alignment
              children:
                  options.map((option) {
                    final isSelected = selected == option;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (_) => setState(() => onSelect(option)),
                        selectedColor: colorScheme.primary,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }

          Widget buildMultiSelectChips(
            List<String> options,
            Set<String> selected,
            void Function(String) onToggle,
          ) {
            return Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Ensures left alignment
              children:
                  options.map((option) {
                    final isSelected = selected.contains(option);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (_) => setState(() => onToggle(option)),
                        selectedColor: colorScheme.primary,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text("Show clubs without availability"),
                    Spacer(),
                    Switch(
                      value: showUnavailable,
                      onChanged:
                          (value) => setState(() => showUnavailable = value),
                      activeColor: colorScheme.primary,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text("Sort by")),
                const SizedBox(height: 8),
                buildFilterChips(
                  ['Relevance', 'Distance', 'Price'],
                  selectedSort,
                  (val) => selectedSort = val,
                ),

                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text("Duration")),
                const SizedBox(height: 8),
                buildFilterChips(
                  ['60 mins', '90 mins', '120 mins'],
                  selectedDuration,
                  (val) => selectedDuration = val,
                ),

                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text("Type")),
                const SizedBox(height: 8),
                buildFilterChips(
                  ['Indoor', 'Outdoor', 'Roofed outdoor'],
                  selectedType,
                  (val) => selectedType = val,
                ),

                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text("Features")),
                const SizedBox(height: 8),
                buildMultiSelectChips(
                  ['Wall', 'Crystal', 'Panoramic'],
                  selectedFeatures,
                  (feature) {
                    if (selectedFeatures.contains(feature)) {
                      selectedFeatures.remove(feature);
                    } else {
                      selectedFeatures.add(feature);
                    }
                  },
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
