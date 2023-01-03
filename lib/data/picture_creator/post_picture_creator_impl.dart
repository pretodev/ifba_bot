import 'package:intl/intl.dart';

import '../../core/post.dart';
import '../../core/post_picture_creator.dart';
import 'file_storage.dart';
import 'picture_creator.dart';

class PostPictureCreatorImpl implements PostPictureCreator {
  final PictureCreator _pictureCreator;
  final FileStorage _fileStorage;

  PostPictureCreatorImpl({
    required PictureCreator pictureCreator,
    required FileStorage fileStorage,
  })  : _pictureCreator = pictureCreator,
        _fileStorage = fileStorage;

  @override
  Future<PostPictureUrl> create(Post post) async {
    final dateFormatted = DateFormat(
      'dd/MM/yyyy HH\'h\'mm',
    ).format(post.publishedAt);
    final args = PictureCreatorArgs(
      siteKey: post.site.key,
      date: dateFormatted,
      origin: post.site.name,
      title: post.title,
    );
    final pictureFile = await _pictureCreator.run(args);
    final pictureUrl = await _fileStorage.upload(pictureFile);
    return pictureUrl;
  }
}
