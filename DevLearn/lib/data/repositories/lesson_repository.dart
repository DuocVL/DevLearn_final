import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/services/lesson_service.dart';

class LessonRepository {
  final LessonService _service = LessonService();

  Future<Lesson> getLessonById(String lessonId) {
    return _service.getLessonById(lessonId);
  }
}
