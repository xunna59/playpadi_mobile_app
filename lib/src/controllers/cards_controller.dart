import '../../playpadi_library.dart';
import '../models/saved_cards_model.dart';

class SavedCardsController {
  final APIClient client = APIClient();

  Future<List<SavedCardModel>> fetchSavedCards() async {
    try {
      final response = await client.fetchSavedCards();
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        // Case A: { data: { sportsCenters: [...] } }
        if (response['data'] is Map<String, dynamic> &&
            response['data']['cards'] is List) {
          rawList = response['data']['cards'];
        } else if (response['cards'] is List) {
          rawList = response['cards'];
        }
      }
      // Case C: Direct list returned
      else if (response is List) {
        rawList = response;
      }

      return rawList
          .map((e) => SavedCardModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log and return empty to keep UI responsive
      return [];
    }
  }
}
