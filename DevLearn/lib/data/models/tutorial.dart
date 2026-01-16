import 'package:devlearn/data/models/author.dart';
import 'package:devlearn/data/models/lesson.dart'; 

class Tutorial {
  final String id;
  final String title;
  final String description;
  final Author author;
  final List<Lesson> lessons; 

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
      ),
      lessons: (json['lessons'] as List? ?? [])
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(), 
    );
  }
}
