import 'package:flutter/material.dart';

class UserActivity {
  final int id;
  final int userId;
  final String type;
  final String description;
  final String ipAddress;
  final String? device; // Only available for login
  final DateTime timestamp;

  UserActivity({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.ipAddress,
    this.device,
    required this.timestamp,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      id: json['id'],
      userId: json['user_id'],
      type: json['activity_type'],
      description: json['description'],
      ipAddress: json['ip_address'],
      device: json['device'], // will be null if not present
      timestamp: DateTime.parse(json['created_at']),
    );
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'match':
        return Icons.sports_esports;
      case 'class':
        return Icons.school;
      default:
        return Icons.device_unknown;
    }
  }
}
