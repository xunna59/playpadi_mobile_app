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
  final String? displayPicture;

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
    this.displayPicture,
  });

  // Factory method to create a UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'] ?? 'John',
      lastName: json['last_name'] ?? 'Doe',
      email: json['email'] ?? '',
      phone: json['phone'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      bio: json['bio'],
      points: json['points'] ?? '0.00',
      accountType: json['account_type'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? false,
      preferences:
          json['preferences'] != null
              ? Map<String, dynamic>.from(json['preferences'])
              : {},
      displayPicture: json['display_picture'],
    );
  }

  // Convert UserProfile to JSON
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
      'display_picture': displayPicture,
    };
  }
}
