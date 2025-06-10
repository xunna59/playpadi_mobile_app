import 'coach_model.dart';
import 'event_center_model.dart';
import 'academy_students_model.dart';

class ClassModel {
  final int id;
  final String title;
  final String description;
  final String? coverImage;
  final String sessionActivity;
  final double sessionPrice;
  final int sessionDuration;
  final int numOfPlayers;
  final String category;
  final String academyType;
  final String activityDate;
  final String endRegistrationDate;
  final CoachModel coach; // Nested CoachModel
  final EventCenter sportsCenter; // Nested SportsCenterModel
  final AcademyStudents academy_students;

  ClassModel({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    required this.sessionActivity,
    required this.sessionPrice,
    required this.sessionDuration,
    required this.numOfPlayers,
    required this.category,
    required this.academyType,
    required this.activityDate,
    required this.endRegistrationDate,
    required this.coach, // Nested
    required this.sportsCenter, // Nested
    required this.academy_students,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    // 1) Safe double conversion
    final rawPrice = json['session_price'];
    final double sessionPrice =
        rawPrice is num
            ? rawPrice.toDouble()
            : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;

    return ClassModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverImage: json['cover_image']?.toString(),
      sessionActivity: json['session_activity']?.toString() ?? '',
      sessionPrice: sessionPrice,
      sessionDuration: (json['session_duration'] as num).toInt(),
      numOfPlayers: (json['num_of_players'] as num).toInt(),
      category: json['category']?.toString() ?? '',
      academyType: json['academy_type']?.toString() ?? '',
      activityDate: json['activity_date']?.toString() ?? '',
      endRegistrationDate: json['end_registration_date']?.toString() ?? '',
      coach: CoachModel.fromJson(
        (json['coach'] as Map<String, dynamic>?) ?? {},
      ),
      sportsCenter: EventCenter.fromJson(
        (json['sportsCenter'] as Map<String, dynamic>?) ?? {},
      ),
      academy_students: AcademyStudents.fromJson(json['academy_students']),
    );
  }
}
