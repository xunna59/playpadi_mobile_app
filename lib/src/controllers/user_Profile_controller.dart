import '../../playpadi_library.dart';
import '../models/user_profile_model.dart';

/// Simple controller for fetching the user profile using APIClient.
class UserProfileController {
  final APIClient client = APIClient();

  /// Fetches the user profile and prints a greeting.
  ///
  /// Returns the [UserProfile] on success, or rethrows exceptions on failure.
  Future<UserProfile> fetchUserProfile() async {
    try {
      final responseData = await client.fetchProfile();

      //   print(responseData);
      var userData = responseData['user'];

      UserProfile profile = UserProfile.fromJson(userData);

      //   print('Hello, ${profile.firstName}!');
      return profile;
    } catch (e) {
      print('Failed to load profile: $e');
      rethrow;
    }
  }

  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      // print('Updating profile with: $updates');

      await client.updateProfile(updates, () {
        print('Profile updated on server');
      });

      final fresh = await fetchUserProfile();
      return fresh;
    } catch (e) {
      rethrow;
    }
  }
}
