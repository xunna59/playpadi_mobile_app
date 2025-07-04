import '../../playpadi_library.dart';
import '../models/class_model.dart';

class AcademyController {
  /// Replace with your real endpoint
  final APIClient client = APIClient();

  Future<List<ClassModel>> getAcademyClasses() async {
    try {
      final response = await client.fetchAcademyClasses();
      //  print(response);
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

  Future<List<ClassModel?>> joinAcademy(Map<String, dynamic> payload) async {
    try {
      final response = await client.joinAcademy(payload);

      List<dynamic> rawList;

      if (response is Map<String, dynamic> && response.containsKey('student')) {
        final student = response['student'];
        rawList = student is List ? student : [student];
      } else if (response is Map<String, dynamic>) {
        // Handle plain object like {id: ..., user_id: ..., ...}
        rawList = [response];
      } else if (response is List) {
        rawList = response;
      } else {
        throw FormatException('Unexpected response format: $response');
      }

      return rawList
          .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
