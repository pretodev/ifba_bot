import 'post.dart';

abstract class PostRepository {
  Future<bool> exists(Post post);

  Future<void> save(Post post);
}
