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
  });

  factory EventCenter.fromJson(Map<String, dynamic> json) {
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
              : ['07:30', '08:00', '08:30', '09:00'], // default if empty
      description: getString(json, 'sports_center_description'),
      status: castOrNull<bool>(json['sports_center_status']),
      latitude: getDouble(json, 'latitude'),
      longitude: getDouble(json, 'longitude'),
      openingHours: getMap(json, 'openingHours'),
      courts:
          (json['courts'] as List)
              .map((courtJson) => CourtModel.fromJson(courtJson))
              .toList(),
      bookingInfo: getMap(json, 'booking_info'),
    );
  }
}
