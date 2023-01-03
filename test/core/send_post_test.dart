import 'package:faker/faker.dart';
import 'package:ifba_bot/core/messenger.dart';
import 'package:ifba_bot/core/post.dart';
import 'package:ifba_bot/core/post_datasource.dart';
import 'package:ifba_bot/core/post_picture_creator.dart';
import 'package:ifba_bot/core/send_post.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../fakers.dart';

class MockPost extends Mock implements Post {}

class MockPostRepository extends Mock implements PostRepository {}

class MockMessenger extends Mock implements Messenger {}

class MockPostPictureCreator extends Mock implements PostPictureCreator {}

void main() {
  group('SendPost', () {
    late PostRepository postRepository;
    late Messenger messenger;
    late SendPost sendPost;
    late PostPictureCreator postPictureCreator;

    setUp(() {
      postRepository = MockPostRepository();
      messenger = MockMessenger();
      postPictureCreator = MockPostPictureCreator();
      sendPost = SendPost(
        postRepository: postRepository,
        messenger: messenger,
        postPictureCreator: postPictureCreator,
      );
    });

    test(
      'deve enviar post e salvar no banco de dados quando post não existir',
      () async {
        final post = MockPost();
        when(() => post.copyWithPictureUrl(any())).thenReturn(post);
        when(() => postRepository.exists(post)).thenAnswer(
          (_) => Future.value(false),
        );
        when(() => postPictureCreator.create(post)).thenAnswer(
          (_) => Future.value(faker.internet.httpUrl()),
        );
        when(() => messenger.sendPost(post)).thenAnswer(
          (_) => Future.value(),
        );
        when(() => postRepository.save(post)).thenAnswer(
          (_) => Future.value(),
        );
        await sendPost(post);
        verify(() => postRepository.exists(post)).called(1);
        verify(() => postPictureCreator.create(post)).called(1);
        verify(() => messenger.sendPost(post)).called(1);
        verify(() => postRepository.save(post)).called(1);
      },
    );

    test('não deve enviar post e salvar no banco de dados quando post existir',
        () async {
      final post = fakePost();
      when(() => postRepository.exists(post))
          .thenAnswer((_) => Future.value(true));
      when(() => postPictureCreator.create(post))
          .thenAnswer((_) => Future.value(faker.internet.httpUrl()));
      when(() => messenger.sendPost(post)).thenAnswer((_) => Future.value());
      when(() => postRepository.save(post)).thenAnswer((_) => Future.value());
      await sendPost(post);
      verify(() => postRepository.exists(post)).called(1);
      verifyNever(() => postPictureCreator.create(post));
      verifyNever(() => messenger.sendPost(post));
      verifyNever(() => postRepository.save(post));
    });
  });
}
