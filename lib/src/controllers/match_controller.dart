import '../../playpadi_library.dart';
import '../models/match_model.dart';

class MatchController {
  final APIClient client = APIClient();

  // final String _url =
  //     'https://xunnatech.com/api/matches.json'; // Replace with your API URL

  // Future<List<MatchModel>> fetchMatches() async {
  //   final response = await http.get(Uri.parse(_url));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => MatchModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load matches');
  //   }
  // }

  Future<List<MatchModel>> getPublicBookings() async {
    try {
      final response = await client.fetchPublicBookings();
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['formattedBookings'] is List) {
          rawList = response['data']['formattedBookings'];
        } else if (response['formattedBookings'] is List) {
          rawList = response['formattedBookings'];
        }
      } else if (response is List) {
        rawList = response;
      }

      final parsed =
          rawList
              .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
              .toList();

      //    print("Parsed classes: ${parsed.length}");
      return parsed;
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }

  Future<List<MatchModel>> createBooking(Map<String, dynamic> payload) async {
    try {
      final response = await client.addBooking(payload);

      List<dynamic> rawList;

      // 1️⃣ If the API returns a single booking under `booking`
      if (response is Map<String, dynamic> && response['booking'] != null) {
        rawList = [response['booking']];
      }
      // 2️⃣ Else if it returns a list directly
      else if (response is List) {
        rawList = response;
      }
      // 3️⃣ Or if it returns { data: [...] }
      else if (response is Map<String, dynamic> && response['data'] is List) {
        rawList = response['data'] as List;
      } else {
        throw FormatException('Unexpected response format: $response');
      }

      // Map each entry to your model
      return rawList
          .map((item) => MatchModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
