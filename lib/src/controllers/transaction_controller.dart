import '../../playpadi_library.dart';
import '../models/transaction_model.dart';

class transactionController {
  final APIClient client = APIClient();

  Future<Map<String, dynamic>> initializePayment(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await client.initializePayment(payload);

      // 1️⃣ Handle top-level 'data' structure
      if (response is Map<String, dynamic> && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }

      // 2️⃣ If success == true and rest is at top level
      if (response is Map<String, dynamic> && response['success'] == true) {
        return {
          'authorization_url': response['authorization_url'],
          'access_code': response['access_code'],
          'reference': response['reference'],
        };
      }

      // 3️⃣ If the structure is unknown or failed
      throw FormatException('Unexpected response format: $response');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> chargeCard(Map<String, dynamic> payload) async {
    try {
      final response = await client.chargeCard(payload);

      if (response is Map<String, dynamic>) {
        // ✅ Case 1: Flat top-level success response (like your current one)
        if (response['status'] == 'success') {
          return response;
        }

        // ✅ Case 2: Nested under 'data' with 'success' flag
        if (response['success'] == true &&
            response['data'] is Map<String, dynamic> &&
            response['data']['status'] == 'success') {
          return response['data'];
        }

        // ✅ Case 3: Authorization initialization
        if (response['success'] == true &&
            response.containsKey('authorization_url') &&
            response.containsKey('reference')) {
          return {
            'authorization_url': response['authorization_url'],
            'access_code': response['access_code'],
            'reference': response['reference'],
          };
        }

        // ❌ If 'status' is not success
        throw Exception(
          'Payment failed: ${response['gateway_response'] ?? 'Unknown error'}',
        );
      }

      // ❌ Completely unrecognized format
      throw FormatException('Unexpected response format: $response');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await client.fetchTransactions(page: page, limit: limit);
      List<dynamic> rawList = [];

      if (response is Map<String, dynamic>) {
        if (response['data'] is Map<String, dynamic> &&
            response['data']['transactions'] is List) {
          rawList = response['data']['transactions'];
        } else if (response['transactions'] is List) {
          rawList = response['transactions'];
        }
      } else if (response is List) {
        rawList = response;
      }

      return rawList.map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }
}
