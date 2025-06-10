// lib/models/match_model.dart

class MatchModel {
  final String dateText; // from json['date']
  final String timeText; // from json['slot']
  final String matchLevel; // from json['game_type']
  final List<Player> players; // from json['players']
  final int totalPlayers; // from json['total_players']
  final String availability; // from json['status']
  final String bookingReference; // from json['booking_reference']
  final double sessionPrice;
  final int sessionDuration;
  final String courtName;
  final String sportsCenterName;
  final String gender_allowed;
  final String cover_image;
  final bool joinedStatus;
  final int id;

  MatchModel({
    required this.dateText,
    required this.timeText,
    required this.matchLevel,
    required this.players,
    required this.totalPlayers,
    required this.availability,
    required this.bookingReference,
    required this.sessionPrice,
    required this.sessionDuration,
    required this.courtName,
    required this.sportsCenterName,
    required this.gender_allowed,
    required this.cover_image,
    required this.joinedStatus,
    required this.id,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      dateText: json['date']?.toString() ?? '',
      timeText: json['slot']?.toString() ?? '',
      matchLevel: json['game_type']?.toString() ?? '',
      availability: json['status']?.toString() ?? '',
      bookingReference: json['booking_reference']?.toString() ?? '',
      totalPlayers: (json['total_players'] as num?)?.toInt() ?? 0,
      sessionPrice:
          json['session_price'] is String
              ? double.tryParse(json['session_price']) ?? 0.0
              : json['session_price']?.toDouble() ?? 0.0,

      sessionDuration:
          json['session_duration'] is String
              ? int.tryParse(json['session_duration']) ?? 0
              : (json['session_duration'] as num?)?.toInt() ?? 0,
      courtName: json['courtName']?.toString() ?? '',
      sportsCenterName: json['sportsCenterName']?.toString() ?? '',
      gender_allowed: json['gender_allowed']?.toString() ?? '',
      cover_image: json['cover_image']?.toString() ?? '',

      players:
          (json['players'] as List<dynamic>? ?? [])
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList(),
      joinedStatus: json['joinedStatus'] as bool? ?? false,
      id:
          json['id'] is String
              ? int.tryParse(json['id']) ?? 0
              : (json['id'] as num?)?.toInt() ?? 0,
    );
  }
}

class Player {
  final String name;
  final double rating;
  final String? avatarUrl;

  Player({required this.name, required this.rating, this.avatarUrl});

  factory Player.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];
    final rating =
        rawRating is num
            ? rawRating.toDouble()
            : double.tryParse(rawRating?.toString() ?? '') ?? 0.0;

    return Player(
      name: json['name']?.toString() ?? '',
      rating: rating,
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}
