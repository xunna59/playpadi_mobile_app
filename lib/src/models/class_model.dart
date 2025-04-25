import 'coach_model.dart';

class ClassModel {
  final String dateGroup;
  final String time;
  final String title;
  final String sport;
  final String location;
  final int courses;
  final bool mixed;
  final CoachModel coach;
  final int spots;
  final double price;
  final bool booked; // ← new

  const ClassModel({
    required this.dateGroup,
    required this.time,
    required this.title,
    required this.sport,
    required this.location,
    required this.courses,
    required this.mixed,
    required this.coach,
    required this.spots,
    required this.price,
    this.booked = false,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    dateGroup: json['dateGroup'] as String,
    time: json['time'] as String,
    title: json['title'] as String,
    sport: json['sport'] as String,
    location: json['location'] as String,
    courses: json['courses'] as int,
    mixed: json['mixed'] as bool,
    coach: CoachModel.fromJson(json['coach'] as Map<String, dynamic>),
    spots: json['spots'] as int,
    price: (json['price'] as num).toDouble(),
    booked: json['booked'] as bool? ?? false, // ← read it if present
  );

  Map<String, dynamic> toJson() => {
    'dateGroup': dateGroup,
    'time': time,
    'title': title,
    'sport': sport,
    'location': location,
    'courses': courses,
    'mixed': mixed,
    'coach': coach.toJson(),
    'spots': spots,
    'price': price,
    'booked': booked, // ← include it
  };
}
