class PlayerPreference {
  final String bestHand;
  final String courtSide;
  final String matchType;
  final bool setByTimeFrame;
  final String play_time;

  PlayerPreference({
    required this.bestHand,
    required this.courtSide,
    required this.matchType,
    required this.setByTimeFrame,
    required this.play_time,
  });

  PlayerPreference copyWith({
    String? bestHand,
    String? courtSide,
    String? matchType,
    bool? setByTimeFrame,
    String? play_time,
  }) {
    return PlayerPreference(
      bestHand: bestHand ?? this.bestHand,
      courtSide: courtSide ?? this.courtSide,
      matchType: matchType ?? this.matchType,
      setByTimeFrame: setByTimeFrame ?? this.setByTimeFrame,
      play_time: play_time ?? this.play_time,
    );
  }

  factory PlayerPreference.initial() => PlayerPreference(
    bestHand: '',
    courtSide: '',
    matchType: '',
    setByTimeFrame: false,
    play_time: '',
  );
}

PlayerPreference playerPreferenceFromMap(Map<String, dynamic> map) {
  return PlayerPreference(
    bestHand: map['best_hand'] ?? '',
    courtSide: map['court_position'] ?? '',
    matchType: map['match_type'] ?? '',
    setByTimeFrame:
        map['set_by_time_frame'] ?? false, // adjust if stored elsewhere
    play_time: map['play_time'] ?? '',
  );
}

Map<String, dynamic> playerPreferenceToMap(PlayerPreference pref) {
  return {
    'best_hand': pref.bestHand,
    'court_position': pref.courtSide,
    'match_type': pref.matchType,
    'play_time': pref.play_time,
    'set_by_time_frame': pref.setByTimeFrame,
  };
}
