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
  final CoachModel coach;
  final EventCenter sportsCenter;
  final AcademyStudents academy_students;
  final bool joinedStatus; // ✅ New field

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
    required this.coach,
    required this.sportsCenter,
    required this.academy_students,
    required this.joinedStatus, // ✅ Added to constructor
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['session_price'];
    final double sessionPrice =
        rawPrice == null
            ? 0.0
            : rawPrice is num
            ? rawPrice.toDouble()
            : double.tryParse(rawPrice.toString()) ?? 0.0;

    return ClassModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverImage: json['cover_image']?.toString(),
      sessionActivity: json['session_activity']?.toString() ?? '',
      sessionPrice: sessionPrice,
      sessionDuration: (json['session_duration'] as num?)?.toInt() ?? 0,
      numOfPlayers: (json['num_of_players'] as num?)?.toInt() ?? 0,
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

      joinedStatus:
          json['joinedStatus'] is bool ? json['joinedStatus'] as bool : false,
    );
  }
}
