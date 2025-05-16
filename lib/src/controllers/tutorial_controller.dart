import '../../playpadi_library.dart';
import '../models/youtube_tutorials_model.dart';

class TutorialService {
  /// Replace with your real endpoint
  final APIClient client = APIClient();

  Future<List<TutorialModel>> fetchYoutubeTutorials() async {
    try {
      final response = await client.youtubeTutorials();

      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['youtubeVideos'] is List) {
          rawList = response['data']['youtubeVideos'];
        } else if (response['youtubeVideos'] is List) {
          rawList = response['youtubeVideos'];
        }
      } else if (response is List) {
        rawList = response;
      }

      final parsed =
          rawList
              .map((e) => TutorialModel.fromJson(e as Map<String, dynamic>))
              .toList();

      print("Parsed tutorials: ${parsed.length}");
      return parsed;
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }
}
