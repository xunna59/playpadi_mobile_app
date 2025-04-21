class PlayerPreference {
  String bestHand;
  String courtSide;
  String matchType;
  String preferredTimeFrame;
  bool setByTimeFrame;
  bool setByDays;

  PlayerPreference({
    required this.bestHand,
    required this.courtSide,
    required this.matchType,
    required this.preferredTimeFrame,
    this.setByTimeFrame = true,
    this.setByDays = false,
  });

  factory PlayerPreference.initial() {
    return PlayerPreference(
      bestHand: 'Right-handed',
      courtSide: 'Backhand',
      matchType: 'Competitive',
      preferredTimeFrame: 'Morning',
    );
  }

  PlayerPreference copyWith({
    String? bestHand,
    String? courtSide,
    String? matchType,
    String? preferredTimeFrame,
    bool? setByTimeFrame,
    bool? setByDays,
  }) {
    return PlayerPreference(
      bestHand: bestHand ?? this.bestHand,
      courtSide: courtSide ?? this.courtSide,
      matchType: matchType ?? this.matchType,
      preferredTimeFrame: preferredTimeFrame ?? this.preferredTimeFrame,
      setByTimeFrame: setByTimeFrame ?? this.setByTimeFrame,
      setByDays: setByDays ?? this.setByDays,
    );
  }
}
