class EventCenter {
  final int id;
  final String name;
  final String address;
  final String coverImage;
  final String sessionPrice;
  final List<String> features;
  final List<String> games;
  final List<String> availableTimes; // if your API ever returns this

  EventCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.coverImage,
    required this.sessionPrice,
    required this.features,
    required this.games,
    required this.availableTimes,
  });

  factory EventCenter.fromJson(Map<String, dynamic> json) {
    return EventCenter(
      id: json['id'] as int,
      name: json['sports_center_name'] as String,
      address: json['sports_center_address'] as String,
      coverImage: json['cover_image'] as String,
      sessionPrice: json['session_price'] as String,
      features: List<String>.from(json['sports_center_features'] ?? []),
      games: List<String>.from(json['sports_center_games'] ?? []),
      availableTimes: List<String>.from(
        json['available_times'] ?? ['07:30', '08:00', '08:30', '09:00'],
      ),
    );
  }
}
