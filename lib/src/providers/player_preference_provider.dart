import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player_preferences_model.dart';
import '../models/user_profile_model.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier(UserProfile userProfile) : super(userProfile);

  /// Derive a typed PlayerPreference from the raw map
  PlayerPreference get playerPreference =>
      playerPreferenceFromMap(state.preferences);

  /// Overwrite just the preference‑keys in the map,
  /// then rebuild a new UserProfile with the updated map
  void updatePlayerPreference(PlayerPreference updatedPref) {
    final updatedMap = Map<String, dynamic>.from(state.preferences)
      ..addAll(playerPreferenceToMap(updatedPref));

    state = UserProfile(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      gender: state.gender,
      dob: state.dob,
      bio: state.bio,
      points: state.points,
      accountType: state.accountType,
      subscriptionStatus: state.subscriptionStatus,
      preferences: updatedMap,
      interests: state.interests,
      displayPicture: state.displayPicture,
      total_matches_played: state.total_matches_played,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
      // Replace with your real fetch logic:
      final initial = UserProfile(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        points: '0.00',
        accountType: 'standard',
        subscriptionStatus: false,
        preferences: {
          'best_hand': 'not set',
          'court_position': 'not set',
          'match_type': 'not set',
          'play_time': 'not set',
        },
        interests: {},
        total_matches_played: '0',
      );
      return UserProfileNotifier(initial);
    });
