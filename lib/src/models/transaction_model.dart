class TransactionModel {
  final int id;
  final int userId;
  final String reference;
  final double amount;
  final String purpose;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.reference,
    required this.amount,
    required this.purpose,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      reference: json['reference'],
      amount: (json['amount'] as num).toDouble(),
      purpose: json['purpose'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
