// lib/models/match_model.dart

class MatchModel {
  final String dateText;
  final String timeText;
  final String matchLevel;
  final List<Player> players;
  final String distanceText;
  final String courtName;
  final double price;
  final int duration;
  final String availability;

  MatchModel({
    required this.dateText,
    required this.timeText,
    required this.matchLevel,
    required this.players,
    required this.distanceText,
    required this.courtName,
    required this.price,
    required this.duration,
    required this.availability,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      dateText: json['dateText'] as String,
      timeText: json['timeText'] as String,
      matchLevel: json['matchLevel'] as String,
      players:
          (json['players'] as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList(),
      distanceText: json['distanceText'] as String,
      courtName: json['courtName'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      availability: json['availability'] as String,
    );
  }
}

class Player {
  final String name;
  final double rating;
  final String? avatarUrl;

  Player({required this.name, required this.rating, this.avatarUrl});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
