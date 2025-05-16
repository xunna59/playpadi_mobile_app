import 'package:flutter/material.dart';
import '../../../models/player_preferences_model.dart';

class PlayerPreferenceScreen extends StatefulWidget {
  const PlayerPreferenceScreen({super.key});

  @override
  State<PlayerPreferenceScreen> createState() => _PlayerPreferenceScreenState();
}

class _PlayerPreferenceScreenState extends State<PlayerPreferenceScreen> {
  PlayerPreference preference = PlayerPreference.initial();

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: const Text('Player preference'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Padel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),

            _buildSectionTitle('Best hand'),
            _buildToggleChips(
              ['Right-handed', 'Left-handed', 'Both hands'],
              preference.bestHand,
              (val) => setState(
                () => preference = preference.copyWith(bestHand: val),
              ),
              selectedColor,
            ),

            const SizedBox(height: 16),
            _buildSectionTitle('Court side'),
            _buildToggleChips(
              ['Backhand', 'Forehand', 'Both side'],
              preference.courtSide,
              (val) => setState(
                () => preference = preference.copyWith(courtSide: val),
              ),
              selectedColor,
            ),

            const SizedBox(height: 16),
            _buildSectionTitle(
              'Match type',
              sub:
                  'The result of the match will count for your level progress if you make it competitive',
            ),
            _buildToggleChips(
              ['Competitive', 'Friendly', 'Both'],
              preference.matchType,
              (val) => setState(
                () => preference = preference.copyWith(matchType: val),
              ),
              selectedColor,
            ),

            const SizedBox(height: 16),
            _buildSectionTitle('Your preferred time to play'),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Set by time frame'),
                Switch(
                  value: preference.setByTimeFrame,
                  onChanged:
                      (val) => setState(
                        () =>
                            preference = preference.copyWith(
                              setByTimeFrame: val,
                            ),
                      ),
                ),
              ],
            ),

            if (preference.setByTimeFrame)
              _buildToggleChips(
                ['Morning', 'Afternoon', 'Evening', 'All day'],
                preference.preferredTimeFrame,
                (val) => setState(
                  () =>
                      preference = preference.copyWith(preferredTimeFrame: val),
                ),
                selectedColor,
              ),

            // const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text('Set by days'),
            //     Switch(
            //       value: preference.setByDays,
            //       onChanged:
            //           (val) => setState(
            //             () => preference = preference.copyWith(setByDays: val),
            //           ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Save preference logic (maybe to SharedPreferences, DB, or API)
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? sub}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (sub != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(sub, style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildToggleChips(
    List<String> options,
    String selected,
    void Function(String) onSelected,
    Color selectedColor,
  ) {
    return Wrap(
      spacing: 8,
      children:
          options.map((option) {
            final isSelected = selected == option;
            return ChoiceChip(
              side: BorderSide.none,
              showCheckmark: false,
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              selectedColor: selectedColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
    );
  }
}
