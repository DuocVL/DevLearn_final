import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/main.dart';

class LessonService {
  final ApiClient _apiClient = apiClient;

  Future<Lesson> getLessonById(String lessonId) async {
    try {
      final response = await _apiClient.get('/lessons/$lessonId');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return Lesson.fromJson(response.data['data']);
      } else {
        throw Exception('Không thể tải bài học');
      }
    } catch (e) {
      print('Failed to load lesson by id: $e');
      throw Exception('Không thể tải bài học: $e');
    }
  }
}
