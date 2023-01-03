import 'post.dart';

abstract class PostPictureCreator {
  Future<PostPictureUrl> create(Post post);
}
