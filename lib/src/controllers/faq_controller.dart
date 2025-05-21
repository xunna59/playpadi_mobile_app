import '../../playpadi_library.dart';
import '../models/faq_model.dart';

class FaqController {
  final APIClient client = APIClient();

  Future<List<Faq>> fetchFaqs() async {
    try {
      final response = await client.fetchFaqs();
      List<dynamic> rawList = [];
      if (response is Map<String, dynamic>) {
        // Case A: { data: { sportsCenters: [...] } }
        if (response['data'] is Map<String, dynamic> &&
            response['data']['faqs'] is List) {
          rawList = response['data']['faqs'];
        } else if (response['faqs'] is List) {
          rawList = response['faqs'];
        }
      }
      // Case C: Direct list returned
      else if (response is List) {
        rawList = response;
      }

      return rawList
          .map((e) => Faq.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log and return empty to keep UI responsive
      return [];
    }
  }
}
