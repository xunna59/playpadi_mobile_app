import '../../playpadi_library.dart';
import '../models/notification_model.dart';

class NotificationController {
  final APIClient client = APIClient();

  Future<List<NotificationData>> fetchNotifications() async {
    try {
      final response = await client.fetchNotifications();
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        // Case A: { data: { sportsCenters: [...] } }
        if (response['data'] is Map<String, dynamic> &&
            response['data']['notifications'] is List) {
          rawList = response['data']['notifications'];
        } else if (response['notifications'] is List) {
          rawList = response['notifications'];
        }
      }
      // Case C: Direct list returned
      else if (response is List) {
        rawList = response;
      }

      return rawList
          .map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log and return empty to keep UI responsive
      return [];
    }
  }

  Future<void> markNotificationRead(Map<String, dynamic> payload) async {
    try {
      final response = await client.markNotificationRead(payload);

      print(response);
      if (response is Map<String, dynamic> && response['success'] == true) {
        // Just log or handle success message if needed
        print('Notification marked as read: ${response['message']}');
      } else {
        throw Exception('Unexpected response: $response');
      }
    } catch (e) {
      rethrow;
    }
  }
}
