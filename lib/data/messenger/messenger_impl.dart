import 'post_sender.dart';

import '../../core/messenger.dart';
import '../../core/post.dart';

class MessengerImpl implements Messenger {
  final PostSender _sender;

  MessengerImpl({
    required PostSender sender,
  }) : _sender = sender;

  @override
  Future<void> sendPost(Post post) async {
    await _sender.send(post);
  }
}
