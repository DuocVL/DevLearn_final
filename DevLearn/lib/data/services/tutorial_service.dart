import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/main.dart';

class TutorialService {
  final ApiClient _apiClient = apiClient;

  // SỬA: Thêm tham số tùy chọn page và limit
  Future<List<TutorialSummary>> getTutorials({int? page, int? limit}) async {
    try {
      final queryParameters = <String, String>{};
      if (page != null) {
        queryParameters['page'] = page.toString();
      }
      if (limit != null) {
        queryParameters['limit'] = limit.toString();
      }

      final response = await _apiClient.get('/tutorials', queryParameters: queryParameters);

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> tutorialJson = response.data['data'];
        return tutorialJson.map((json) => TutorialSummary.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to load tutorials: $e');
      throw Exception('Failed to load tutorials: $e');
    }
  }

  Future<Tutorial> getTutorialById(String id) async {
    try {
      final response = await _apiClient.get('/tutorials/$id');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return Tutorial.fromJson(response.data['data']);
      } else {
        throw Exception('Không thể tải hướng dẫn');
      }
    } catch (e) {
      print('Failed to load tutorial by id: $e');
      throw Exception('Không thể tải hướng dẫn');
    }
  }

  Future<List<LessonSummary>> getLessonsForTutorial(String tutorialId) async {
    try {
      final response = await _apiClient.get('/tutorials/$tutorialId/lessons');
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> lessonsJson = response.data['data'];
        return lessonsJson.map((json) => LessonSummary.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to load lessons for tutorial: $e');
      throw Exception('Failed to load lessons for tutorial: $e');
    }
  }
}
