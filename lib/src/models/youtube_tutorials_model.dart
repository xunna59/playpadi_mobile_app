class TutorialModel {
  // final String id;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final DateTime publishedAt;
  final String youtubeUrl;

  TutorialModel({
    //  required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.publishedAt,
    required this.youtubeUrl,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      // id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      duration: json['duration'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      youtubeUrl: json['youtube_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    // 'id': id,
    'title': title,
    'thumbnailUrl': thumbnailUrl,
    'durationSeconds': duration,
    'publishedAt': publishedAt.toIso8601String(),
    'youtubeUrl': youtubeUrl,
  };
}
