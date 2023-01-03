import 'package:ifba_bot/data/messenger/messenger_impl.dart';
import 'package:ifba_bot/data/messenger/post_sender.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fakers.dart';

class MockPostSender extends Mock implements PostSender {}

void main() {
  group("TelegramMessenger", () {
    late PostSender postSender;
    late MessengerImpl telegramMessenger;

    setUp(() {
      postSender = MockPostSender();
      telegramMessenger = MessengerImpl(sender: postSender);
    });

    test("deve enviar post", () async {
      final post = fakePost();
      when(() => postSender.send(post)).thenAnswer((_) async => {});
      await telegramMessenger.sendPost(post);
      verify(() => postSender.send(post)).called(1);
    });
  });
}
