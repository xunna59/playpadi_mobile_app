import 'transaction_model.dart';

class TransactionListResponse {
  final bool success;
  final int currentPage;
  final int totalPages;
  final int totalTransactions;
  final List<TransactionModel> transactions;

  TransactionListResponse({
    required this.success,
    required this.currentPage,
    required this.totalPages,
    required this.totalTransactions,
    required this.transactions,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    return TransactionListResponse(
      success: json['success'] ?? false,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalTransactions: json['totalTransactions'] ?? 0,
      transactions:
          (json['transactions'] as List)
              .map((item) => TransactionModel.fromJson(item))
              .toList(),
    );
  }
}
