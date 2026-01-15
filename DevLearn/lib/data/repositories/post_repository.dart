import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/services/post_service.dart';

class PostRepository {
  // SỬA: Khởi tạo PostService mà không cần tham số
  final PostService _service = PostService();

  /// Fetches a paginated list of posts.
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) {
    return _service.getPosts(page: page, limit: limit);
  }

  /// Creates a new post.
  Future<void> createPost({
    required String title,
    required String content,
    required List<String> tags,
    required bool isAnonymous,
    required String status,
  }) {
    return _service.createPost(
      title: title,
      content: content,
      tags: tags,
      isAnonymous: isAnonymous,
      status: status,
    );
  }
}
