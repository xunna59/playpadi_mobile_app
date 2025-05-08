class CoachModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String address;
  final String? displayPicture;
  final String createdAt;
  final String updatedAt;

  CoachModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.address,
    this.displayPicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      displayPicture: json['display_picture']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
