import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

import '../../core/post.dart';
import '../../data/messenger/post_sender.dart';

class TelegramPostSender implements PostSender {
  final String chatId;
  final String botName;
  final String botToken;

  late final TeleDart _teleDart;

  TelegramPostSender({
    required this.chatId,
    required this.botName,
    required this.botToken,
  }) {
    _teleDart = TeleDart(
      botToken,
      Event(botName),
    );
  }

  @override
  Future<void> send(Post post) async {
    await _teleDart.sendPhoto(
      chatId,
      post.pictureUrl,
      caption: post.title,
      reply_markup: InlineKeyboardMarkup(inline_keyboard: [
        [
          InlineKeyboardButton(
            text: 'Ver mais',
            url: post.pageUrl,
          ),
        ],
      ]),
    );
    await _teleDart.sendMessage(
      chatId,
      'Comentários',
    );
  }
}
