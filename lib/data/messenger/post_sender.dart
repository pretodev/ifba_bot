import '../../core/post.dart';

abstract class PostSender {
  Future<void> send(Post post);
}
