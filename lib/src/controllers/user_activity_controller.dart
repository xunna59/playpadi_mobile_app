import '../../playpadi_library.dart';
import '../models/user_activity_model.dart';

class userActivityController {
  final APIClient client = APIClient();

  Future<List<UserActivity>> fetchUserActivity({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await client.fetchUserActivity(page: page, limit: limit);
      List<dynamic> rawList = [];

      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['activities'] is List) {
          rawList = response['data']['activities'];
        } else if (response['activities'] is List) {
          rawList = response['activities'];
        }
      } else if (response is List) {
        rawList = response;
      }

      return rawList.map((e) => UserActivity.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }
}
