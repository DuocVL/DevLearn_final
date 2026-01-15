import 'package:devlearn/data/models/author.dart';
import 'package:devlearn/data/models/lesson.dart'; // Sửa từ lesson_summary.dart thành lesson.dart nếu cần

class Tutorial {
  final String id;
  final String title;
  final String description;
  final Author author;
  final List<Lesson> lessons; // SỬA: Thay LessonSummary bằng Lesson

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.lessons,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: Author.fromJson(json['author'] ?? {},
      ), // Cung cấp giá trị mặc định
      lessons: (json['lessons'] as List? ?? [])
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(), // SỬA: Dùng Lesson.fromJson
    );
  }
}
