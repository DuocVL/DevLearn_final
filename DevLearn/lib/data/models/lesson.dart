class Lesson {
  final String id;
  final String title;
  final String content;
  final int order;
  final int likeCount;
  final int unlikeCount;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Thêm một trường đơn giản để giữ ID của tutorial
  final String tutorialId;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    required this.likeCount,
    required this.unlikeCount,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    required this.tutorialId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // API trả về tutorialId là một object, ta chỉ cần lấy _id từ nó
    final tutorialInfo = json['tutorialId'] as Map<String, dynamic>? ?? {};

    return Lesson(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      order: json['order'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      unlikeCount: json['unlikeCount'] ?? 0,
      views: json['views'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      tutorialId: tutorialInfo['_id'] ?? '',
    );
  }
}
