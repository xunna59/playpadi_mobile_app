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
  final List<CourtData> courtData;

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
    required this.courtData,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'] ?? 0, // Default to 0 if not provided
      name: json['court_name'] ?? '', // Default to empty string if null
      location: json['court_location'] ?? '', // Default to empty string if null
      type: json['court_type'] ?? '', // Default to empty string if null
      activity: json['activity'] ?? '', // Default to empty string if null
      sessionPrice:
          double.tryParse(json['session_price']?.toString() ?? '0') ??
          0.0, // Parse price safely with default 0.0
      sessionDuration:
          json['session_duration'] ?? 0, // Default to 0 if not provided
      position: json['court_position'] ?? '', // Default to empty string if null
      bookingInfo: _decodeBookingInfo(
        json['booking_info'],
      ), // Handle decoding logic
      status: json['status'] ?? '', // Default to empty string if null
      courtData: _decodeCourtData(
        json['court_data'], // Use the new court_data field
      ),
    );
  }

  // Helper method to handle the booking info decoding logic
  static Map<String, dynamic> _decodeBookingInfo(dynamic bookingInfo) {
    if (bookingInfo == null) {
      return {}; // Return an empty map if bookingInfo is null
    }
    if (bookingInfo is String) {
      try {
        return jsonDecode(bookingInfo); // Decode string to Map
      } catch (e) {
        return {}; // Return an empty map if decoding fails
      }
    } else if (bookingInfo is Map<String, dynamic>) {
      return bookingInfo; // Return it as-is if it's already a Map
    }
    return {}; // Return an empty map as fallback
  }

  static List<CourtData> _decodeCourtData(dynamic courtData) {
    if (courtData == null) {
      return []; // Return an empty list if courtData is null
    }

    // Ensure that courtData is a List, else return an empty list
    if (courtData is List) {
      try {
        return courtData.map((data) => CourtData.fromJson(data)).toList();
      } catch (e) {
        print("Error decoding court data: $e");
        return []; // Return an empty list if decoding fails
      }
    }

    print("courtData is not a List, it is: ${courtData.runtimeType}");
    return []; // Return an empty list as fallback
  }
}

class CourtData {
  final int price;
  final int duration;

  CourtData({required this.price, required this.duration});

  factory CourtData.fromJson(Map<String, dynamic> json) {
    return CourtData(
      price:
          int.tryParse(json['price'].toString()) ?? 0, // Convert String to int
      duration:
          int.tryParse(json['duration'].toString()) ??
          0, // Convert String to int
    );
  }
}
