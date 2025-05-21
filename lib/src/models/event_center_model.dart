import '../utils/json_helper.dart';
import 'court_model.dart';

class EventCenter {
  final int id;
  final String name;
  final String address;
  final String coverImage;
  final String sessionPrice;
  final List<String> features;
  final List<String> games;
  final List<String> availableTimes; // if your API ever returns this
  final String description;
  final bool? status; // NEW
  final double? latitude; // NEW
  final double? longitude; // NEW
  final Map<String, dynamic>? openingHours; // NEW
  final List<CourtModel>? courts;
  final Map<String, dynamic>? bookingInfo; // NEW
  final int? total_courts;
  final String? website;
  final String? phone;

  EventCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.coverImage,
    required this.sessionPrice,
    required this.features,
    required this.games,
    required this.availableTimes,
    required this.description,
    this.status,
    this.latitude,
    this.longitude,
    this.openingHours,
    required this.courts,
    this.bookingInfo,
    this.total_courts,
    this.website,
    this.phone,
  });

  factory EventCenter.fromJson(Map<String, dynamic> json) {
    // Safely pull out courts, default to empty list if missing or not a List
    final courtsJson = json['courts'];
    final courts =
        (courtsJson is List)
            ? courtsJson
                .cast<Map<String, dynamic>>()
                .map((c) => CourtModel.fromJson(c))
                .toList()
            : <CourtModel>[];

    return EventCenter(
      id: getInt(json, 'id'),
      name: getString(json, 'sports_center_name'),
      address: getString(json, 'sports_center_address'),
      coverImage: getString(json, 'cover_image'),
      sessionPrice: getString(json, 'session_price'),
      features: getStringList(json, 'sports_center_features'),
      games: getStringList(json, 'sports_center_games'),
      availableTimes:
          getStringList(json, 'available_times').isNotEmpty
              ? getStringList(json, 'available_times')
              : ['07:30', '08:00', '08:30', '09:00'],
      // If description key is missing, default to empty string
      description: getString(
        json,
        'sports_center_description',
        defaultValue: '',
      ),
      status: castOrNull<bool>(json['sports_center_status']),
      latitude: getDouble(json, 'latitude'),
      longitude: getDouble(json, 'longitude'),
      openingHours: getMap(json, 'openingHours'),
      courts: courts,
      bookingInfo: getMap(json, 'booking_info'),
      total_courts: getInt(json, 'total_courts'),
      website: getString(json, 'website'),
      phone: getString(json, 'phone'),
    );
  }
}
