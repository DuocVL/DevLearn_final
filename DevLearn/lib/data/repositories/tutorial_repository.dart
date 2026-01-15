import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/tutorial_service.dart';

class TutorialRepository {
  final TutorialService _service = TutorialService();

  // SỬA: Thêm tham số tùy chọn page và limit
  Future<List<TutorialSummary>> getTutorials({int? page, int? limit}) {
    return _service.getTutorials(page: page, limit: limit);
  }

  // Lấy thông tin chi tiết của một tutorial
  Future<Tutorial> getTutorialById(String id) {
    return _service.getTutorialById(id);
  }

  // Lấy danh sách các bài học của một tutorial
  Future<List<LessonSummary>> getLessonsForTutorial(String tutorialId) {
    return _service.getLessonsForTutorial(tutorialId);
  }
}
