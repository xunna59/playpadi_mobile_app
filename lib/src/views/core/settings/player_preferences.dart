import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/user_Profile_controller.dart';
import '../../../core/activity_overlay.dart';
import '../../../models/player_preferences_model.dart';
import '../../../providers/player_preference_provider.dart';

class PlayerPreferenceScreen extends ConsumerWidget {
  const PlayerPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) watch the current UserProfile
    final userProfile = ref.watch(userProfileProvider);
    // 2) grab the notifier to mutate it
    final profileNotifier = ref.read(userProfileProvider.notifier);
    // 3) derive a typed PlayerPreference
    final preference = profileNotifier.playerPreference;

    final selectedColor = Theme.of(context).colorScheme.primary;

    final controller = UserProfileController();

    void _save() async {
      final userProfile = ref.read(userProfileProvider);
      final playerPref = playerPreferenceFromMap(userProfile.preferences);

      // Convert to map
      final prefMap = playerPreferenceToMap(playerPref);

      // Remove 'set_by_time_frame' from the map
      prefMap.remove('set_by_time_frame');

      final updates = {"preferences": prefMap};

      print(updates);

      LoadingOverlay.show(context);
      try {
        final updatedProfile = await controller.updateUserProfile(updates);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile updated successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile: ${e.toString()}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        LoadingOverlay.hide();
      }
    }

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

            // Best hand
            _buildSectionTitle('Best hand'),
            _buildToggleChips(
              ['Right-handed', 'Left-handed', 'Both hands'],
              preference.bestHand,
              (val) {
                final updated = preference.copyWith(bestHand: val);
                profileNotifier.updatePlayerPreference(updated);
              },
              selectedColor,
            ),

            const SizedBox(height: 16),
            // Court side
            _buildSectionTitle('Court side'),
            _buildToggleChips(
              ['Backhand', 'Forehand', 'Both side'],
              preference.courtSide,
              (val) {
                final updated = preference.copyWith(courtSide: val);
                profileNotifier.updatePlayerPreference(updated);
              },
              selectedColor,
            ),

            const SizedBox(height: 16),
            // Match type
            _buildSectionTitle(
              'Match type',
              sub:
                  'The result will count for your level progress if competitive',
            ),
            _buildToggleChips(
              ['Competitive', 'Friendly', 'Both'],
              preference.matchType,
              (val) {
                final updated = preference.copyWith(matchType: val);
                profileNotifier.updatePlayerPreference(updated);
              },
              selectedColor,
            ),

            const SizedBox(height: 16),
            // Preferred time
            _buildSectionTitle('Your preferred time to play'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Set by time frame'),
                Switch(
                  value: preference.setByTimeFrame,
                  onChanged: (val) {
                    final updated = preference.copyWith(setByTimeFrame: val);
                    profileNotifier.updatePlayerPreference(updated);
                  },
                ),
              ],
            ),

            if (preference.setByTimeFrame) ...[
              _buildToggleChips(
                ['Morning', 'Afternoon', 'Evening', 'All day'],
                preference.play_time,
                (val) {
                  final updated = preference.copyWith(play_time: val);
                  profileNotifier.updatePlayerPreference(updated);
                },
                selectedColor,
              ),
            ],

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
                onPressed: _save,

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

  Widget _buildSectionTitle(String title, {String? sub}) => Column(
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

  Widget _buildToggleChips(
    List<String> options,
    String selectedValue,
    void Function(String) onSelected,
    Color selectedColor,
  ) => Wrap(
    spacing: 8,
    children:
        options.map((option) {
          final isSelected = selectedValue == option;
          return ChoiceChip(
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
