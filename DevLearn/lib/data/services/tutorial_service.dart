import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/main.dart';

class TutorialService {
  final ApiClient _apiClient = apiClient;

  Future<List<TutorialSummary>> getTutorials() async {
    try {
      final response = await _apiClient.get('/tutorials');
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
        // Sửa ở đây: Lấy dữ liệu từ khóa 'data'
        return Tutorial.fromJson(response.data['data']);
      } else {
        throw Exception('Không thể tải hướng dẫn');
      }
    } catch (e) {
      print('Failed to load tutorial by id: $e');
      throw Exception('Không thể tải hướng dẫn');
    }
  }
}
