import '../../playpadi_library.dart';
import '../models/class_model.dart';

class AcademyController {
  /// Replace with your real endpoint
  final APIClient client = APIClient();

  Future<List<ClassModel>> getAcademyClasses() async {
    try {
      final response = await client.fetchAcademyClasses();
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['academies'] is List) {
          rawList = response['data']['academies'];
        } else if (response['academies'] is List) {
          rawList = response['academies'];
        }
      } else if (response is List) {
        rawList = response;
      }

      final parsed =
          rawList
              .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
              .toList();

      print("Parsed classes: ${parsed.length}");
      return parsed;
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }
}
