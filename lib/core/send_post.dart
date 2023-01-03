import 'messenger.dart';
import 'post.dart';
import 'post_datasource.dart';
import 'post_picture_creator.dart';

class SendPost {
  final PostRepository postRepository;
  final PostPictureCreator postPictureCreator;
  final Messenger messenger;

  SendPost({
    required this.postRepository,
    required this.postPictureCreator,
    required this.messenger,
  });

  Future<void> call(Post post) async {
    if (await postRepository.exists(post)) {
      return;
    }
    final pictureUrl = await postPictureCreator.create(post);
    post = post.copyWithPictureUrl(pictureUrl);
    await messenger.sendPost(post);
    await postRepository.save(post);
    print('Novo post enviado');
  }
}
