class LessonSummary {
  final String id;
  final String title;
  final DateTime createdAt;

  LessonSummary({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory LessonSummary.fromJson(Map<String, dynamic> json) {
    return LessonSummary(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Không có tiêu đề',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
