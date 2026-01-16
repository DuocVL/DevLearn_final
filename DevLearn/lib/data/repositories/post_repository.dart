import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/services/post_service.dart';

class PostRepository {

  final PostService _service = PostService();


  Future<List<Post>> getPosts({int page = 1, int limit = 20}) {
    return _service.getPosts(page: page, limit: limit);
  }


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
