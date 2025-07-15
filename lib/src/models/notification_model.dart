class NotificationData {
  final int id;
  final String title;
  final String description;
  final bool isRead;
  final String createdAt; // <-- new field

  NotificationData({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false,
    required this.createdAt, // <-- required
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'] as String,
      description: json['description'] as String,
      isRead: json['read'] as bool? ?? false,
      createdAt: json['created_at'] as String, // <-- parsing ISO string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isRead': isRead,
      'created_at': createdAt,
    };
  }

  NotificationData copyWith({
    int? id,
    String? title,
    String? description,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DateTime get parsedCreatedAt => DateTime.parse(createdAt);
}
