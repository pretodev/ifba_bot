import 'post.dart';

abstract class Messenger {
  Future<void> sendPost(Post post);
}
