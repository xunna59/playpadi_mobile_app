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
  final bool isFavourite;

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
    required this.isFavourite,
  });

  EventCenter copyWith({
    int? id,
    String? name,
    String? address,
    String? coverImage,
    String? sessionPrice,
    List<String>? features,
    List<String>? games,
    List<String>? availableTimes,
    String? description,
    bool? status,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? openingHours,
    List<CourtModel>? courts,
    Map<String, dynamic>? bookingInfo,
    int? total_courts,
    String? website,
    String? phone,
    bool? isFavourite,
  }) {
    return EventCenter(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      coverImage: coverImage ?? this.coverImage,
      sessionPrice: sessionPrice ?? this.sessionPrice,
      features: features ?? this.features,
      games: games ?? this.games,
      availableTimes: availableTimes ?? this.availableTimes,
      description: description ?? this.description,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      courts: courts ?? this.courts,
      bookingInfo: bookingInfo ?? this.bookingInfo,
      total_courts: total_courts ?? this.total_courts,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

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
      isFavourite: castOrNull<bool>(json['isSaved']) ?? false,
    );
  }
}
