import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/tutorial_service.dart';

class TutorialRepository {
  final TutorialService _service = TutorialService();

  Future<List<TutorialSummary>> getTutorials({int? page, int? limit}) {
    return _service.getTutorials(page: page, limit: limit);
  }

  Future<Tutorial> getTutorialById(String id) {
    return _service.getTutorialById(id);
  }

  // SỬA: Thay LessonSummary bằng Lesson
  Future<List<Lesson>> getLessonsForTutorial(String tutorialId) {
    return _service.getLessonsForTutorial(tutorialId);
  }
}
