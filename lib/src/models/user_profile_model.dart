class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? gender;
  final DateTime? dob;
  final String? bio;
  final String points;
  final String accountType;
  final bool subscriptionStatus;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> interests;
  final String? displayPicture;
  final String total_matches_played;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.gender,
    this.dob,
    this.bio,
    required this.points,
    required this.accountType,
    required this.subscriptionStatus,
    required this.preferences,
    required this.interests,
    this.displayPicture,
    required this.total_matches_played,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'] ?? 'John',
      lastName: json['last_name'] ?? 'Doe',
      email: json['email'] ?? '',
      phone: json['phone'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      bio: json['bio'],
      points: json['points']?.toString() ?? '0.00',
      accountType: json['account_type'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? false,
      preferences:
          json['preferences'] != null
              ? Map<String, dynamic>.from(json['preferences'])
              : {},
      interests:
          json['interests'] != null
              ? Map<String, dynamic>.from(json['interests'])
              : {},
      displayPicture: json['display_picture'],
      total_matches_played: json['total_matches_played'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'bio': bio,
      'points': points,
      'account_type': accountType,
      'subscription_status': subscriptionStatus,
      'preferences': preferences,
      'interests': interests,
      'display_picture': displayPicture,
      'total_matches_played': total_matches_played,
    };
  }
}
