class TutorialModel {
  final int id;
  final String videoTitle;
  final String youtubeUrl;
  final String videoDuration;
  final String uploadDate;
  final String coverImage;

  TutorialModel({
    required this.id,
    required this.videoTitle,
    required this.youtubeUrl,
    required this.videoDuration,
    required this.uploadDate,
    required this.coverImage,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      id: json['id'],
      videoTitle: json['video_title'] ?? '',
      youtubeUrl: json['youtube_url'] ?? '',
      videoDuration: json['video_duration'] ?? '',
      uploadDate: json['upload_date'] ?? '',
      coverImage: json['cover_image'] ?? '',
    );
  }
}
