import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/main.dart';

class PostService {
  final ApiClient _apiClient = apiClient;


  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
   
      final List<dynamic> postData = response.data['data'];
      return postData.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching posts in PostService: $e');
      throw Exception('Failed to fetch posts.');
    }
  }

  /// Creates a new post.
  Future<void> createPost({
    required String title,
    required String content,
    required List<String> tags,
    required bool isAnonymous,
    required String status,
  }) async {
    try {
      await _apiClient.post(
        '/posts',
        data: {
          'title': title,
          'content': content,
          'tags': tags,
          'anonymous': isAnonymous,
          'status': status,
        },
      );
    } catch (e) {
      print('Error creating post in PostService: $e');
      throw Exception('Failed to create post. Please try again.');
    }
  }
}
