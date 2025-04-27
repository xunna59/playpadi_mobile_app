import 'dart:convert'; // Import this for json.decode

class CourtModel {
  final int id;
  final String name;
  final String location;
  final String type;
  final String activity;
  final double sessionPrice;
  final int sessionDuration;
  final String position;
  final Map<String, dynamic> bookingInfo; // Now it's a Map
  final String status;

  CourtModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.activity,
    required this.sessionPrice,
    required this.sessionDuration,
    required this.position,
    required this.bookingInfo,
    required this.status,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'],
      name: json['court_name'],
      location: json['court_location'],
      type: json['court_type'],
      activity: json['activity'],
      sessionPrice: double.tryParse(json['session_price']) ?? 0.0,
      sessionDuration: json['session_duration'],
      position: json['court_position'],
      bookingInfo:
          json['booking_info'] != null
              ? jsonDecode(
                json['booking_info'],
              ) // Decode the booking_info string to a Map
              : {}, // If booking_info is null or empty, return an empty Map
      status: json['status'],
    );
  }
}
