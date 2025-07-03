import 'package:flutter/material.dart';

class UserActivity {
  final String type;
  final String description;
  final String? deviceType;
  final DateTime timestamp;

  UserActivity({
    required this.type,
    required this.description,
    this.deviceType,
    required this.timestamp,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      type: json['type'],
      description: json['description'],
      deviceType: json['device_type'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'match':
        return Icons.sports_tennis;
      case 'class':
        return Icons.school;
      default:
        return Icons.device_unknown; // fallback for unknown types
    }
  }
}
