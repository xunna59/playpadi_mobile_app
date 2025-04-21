class CourtModel {
  final String name;
  final String features;
  final List<Pricing> pricing;

  CourtModel({
    required this.name,
    required this.features,
    required this.pricing,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      name: json['name'],
      features: json['features'],
      pricing:
          (json['pricing'] as List).map((e) => Pricing.fromJson(e)).toList(),
    );
  }
}

class Pricing {
  final double amount;
  final String duration;

  Pricing({required this.amount, required this.duration});

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      amount: (json['amount'] as num).toDouble(),
      duration: json['duration'],
    );
  }
}
