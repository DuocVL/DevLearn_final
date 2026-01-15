class Lesson {
  final String id;
  final String title;
  final String content;
  final int duration;
  final String videoUrl;
  final String tutorialId;
  final bool isPreviewable;
  final int views;
  final int likeCount;
  final int unlikeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    required this.videoUrl,
    required this.tutorialId,
    required this.isPreviewable,
    required this.views,
    required this.likeCount,
    required this.unlikeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'], // API trả về `_id` cho lessons
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      duration: json['duration'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      tutorialId: json['tutorialId'] ?? '',
      isPreviewable: json['isPreviewable'] ?? false,
      views: json['views'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      unlikeCount: json['unlikeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
