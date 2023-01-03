import 'dart:async';

import 'package:ifba_bot/core/scrape_posts.dart';
import 'package:ifba_bot/core/post_site_repository.dart';
import 'package:ifba_bot/core/scrapping_executor.dart';
import 'package:ifba_bot/core/send_post.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../fakers.dart';

class MockSendPost extends Mock implements SendPost {}

class MockScrappingExecutor extends Mock implements ScrappingExecutor {}

class MockPostSiteRepository extends Mock implements PostSiteRepository {}

void main() {
  group('ScrapePosts', () {
    late SendPost sendPost;
    late ScrappingExecutor scrappingExecutor;
    late PostSiteRepository postSiteRepository;
    late ScrapePosts executePostScrapping;

    setUpAll(() {
      registerFallbackValue(fakePost());
    });

    setUp(() {
      sendPost = MockSendPost();
      scrappingExecutor = MockScrappingExecutor();
      postSiteRepository = MockPostSiteRepository();
      executePostScrapping = ScrapePosts(
        sendPost: sendPost,
        scrappingExecutor: scrappingExecutor,
        postSiteRepository: postSiteRepository,
      );
    });

    test(
        'deve enviar post retornado do mais antigo para o mais novo pelo scrapping',
        () async {
      final sites = fakePostSites();
      final posts = fakePosts(15);
      when(() => postSiteRepository.getAllSites())
          .thenAnswer((_) async => sites);
      when(() => scrappingExecutor.scrapePosts(sites))
          .thenAnswer((_) async => posts);
      when(() => sendPost.call(any())).thenAnswer((_) => Future.value());
      await executePostScrapping();
      verify(() => postSiteRepository.getAllSites()).called(1);
      verify(() => scrappingExecutor.scrapePosts(sites)).called(1);
      posts.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final calls = posts
          .take(ScrapePosts.maxNewPosts)
          .toList()
          .reversed
          .map((post) => () => sendPost(post))
          .toList();
      verifyInOrder(calls);
    });

    test('deve enviar o máximo de posts novos permitido', () async {
      final sites = fakePostSites();
      final posts = fakePosts(15);
      when(() => postSiteRepository.getAllSites())
          .thenAnswer((_) async => sites);
      when(() => scrappingExecutor.scrapePosts(sites))
          .thenAnswer((_) async => posts);
      when(() => sendPost.call(any())).thenAnswer((_) => Future.value());
      await executePostScrapping();
      verify(() => postSiteRepository.getAllSites()).called(1);
      verify(() => scrappingExecutor.scrapePosts(sites)).called(1);
      verify(() => sendPost(any())).called(
        lessThanOrEqualTo(ScrapePosts.maxNewPosts),
      );
    });
  });
}
