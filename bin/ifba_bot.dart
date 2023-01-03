import 'dart:async';

import 'package:ifba_bot/core/scrape_posts.dart';
import 'package:ifba_bot/core/send_post.dart';
import 'package:ifba_bot/data/picture_creator/post_picture_creator_impl.dart';
import 'package:ifba_bot/external/pupperteer/pupperteer_browser.dart';
import 'package:ifba_bot/external/pupperteer/pupperteer_scrapping_creator.dart';
import 'package:ifba_bot/external/python/python_picture_creator.dart';
import 'package:ifba_bot/external/supabase/supabse_file_storage.dart';
import 'package:ifba_bot/external/telegram/telegram.dart';
import 'package:ifba_bot/data/messenger/messenger_impl.dart';
import 'package:ifba_bot/external/supabase/supabase_post_datasource.dart';
import 'package:ifba_bot/external/supabase/supabase_post_site_datasource.dart';
import 'package:ifba_bot/data/repositories/post_repository_impl.dart';
import 'package:ifba_bot/data/repositories/post_site_repository_impl.dart';
import 'package:ifba_bot/data/scrapping/scrapping_executor_impl.dart';
import 'package:supabase/supabase.dart';

void main(List<String> arguments) async {
  final supabase = SupabaseClient(
    String.fromEnvironment('SUPABASE_URL'),
    String.fromEnvironment('SUPABASE_KEY'),
  );

  final telegramSender = TelegramPostSender(
    botName: String.fromEnvironment('TELEGRAM_BOT_NAME'),
    botToken: String.fromEnvironment('TELEGRAM_TOKEN'),
    chatId: String.fromEnvironment('TELEGRAM_CHAT_ID'),
  );

  // repositories
  final postSiteDatasource = SupabasePostSiteDatasource(
    supabaseClient: supabase,
  );
  final postSiteRepository = PostSiteRepositoryImpl(
    postSiteDatasource: postSiteDatasource,
  );
  final postDatasource = SupabasePostDatasource(
    supabaseClient: supabase,
  );
  final postRepository = PostRepositoryImpl(
    postDatasource: postDatasource,
    postSiteDatasource: postSiteDatasource,
  );

  // scrapping
  final scrappingBrowser = PupperteerBrowser();
  final scrappingCreator = PupperteerScrappingCreator();
  final scrappingExecutor = ScrappingExecutorImpl(
    browser: scrappingBrowser,
    scrappingCreator: scrappingCreator,
  );

  // messenger
  final messenger = MessengerImpl(sender: telegramSender);

  // image creator
  final pictureCreator = PythonPictureCreator(
    scriptPath: String.fromEnvironment('PYTHON_PICTURE_CREATOR'),
  );
  final fileStorage = SupabseFileStorage(
    supabaseClient: supabase,
  );
  final postPictureCreator = PostPictureCreatorImpl(
    pictureCreator: pictureCreator,
    fileStorage: fileStorage,
  );

  // use cases
  final sendPost = SendPost(
    postRepository: postRepository,
    messenger: messenger,
    postPictureCreator: postPictureCreator,
  );
  final executePostScrapping = ScrapePosts(
    sendPost: sendPost,
    scrappingExecutor: scrappingExecutor,
    postSiteRepository: postSiteRepository,
  );

  runner([Timer? timer]) async {
    print('Executando o scrapping');
    await executePostScrapping();
    print('Pausando o scrapping');
  }

  print('Inicializando o bot');
  Timer.periodic(Duration(minutes: 15), runner);
  runner();
}
