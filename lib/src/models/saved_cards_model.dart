class SavedCardModel {
  final int id;
  final String lastFour;
  final String cardType;
  final int expMonth;
  final int expYear;
  final DateTime createdAt;

  SavedCardModel({
    required this.id,
    required this.lastFour,
    required this.cardType,
    required this.expMonth,
    required this.expYear,
    required this.createdAt,
  });

  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    return SavedCardModel(
      id: json['id'],
      lastFour: json['last_four'],
      cardType: json['cardType'] ?? '',
      expMonth: json['expMonth'],
      expYear: json['expYear'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_four': lastFour,
      'cardType': cardType,
      'expMonth': expMonth,
      'expYear': expYear,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
