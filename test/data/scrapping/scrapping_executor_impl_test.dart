import 'package:faker/faker.dart';
import 'package:ifba_bot/core/failures.dart';
import 'package:ifba_bot/core/post.dart';
import 'package:ifba_bot/data/scrapping/scrapping_browser.dart';
import 'package:ifba_bot/data/scrapping/scrapping_creator.dart';
import 'package:ifba_bot/data/scrapping/scrapping_executor_impl.dart';
import 'package:ifba_bot/data/scrapping/scrapping.dart';
import 'package:mocktail/mocktail.dart';
import 'package:puppeteer/puppeteer.dart';

import 'package:test/test.dart';

import '../../fakers.dart';

class MockSiteScrapping extends Mock implements Scrapping {}

class MockScrappingBrowser extends Mock implements ScrappingBrowser {}

class MockScrappingCreator extends Mock implements ScrappingCreator {}

class MockBrowser extends Mock implements Browser {}

void main() {
  group("ScrappingExecutorImpl", () {
    late MockScrappingCreator creator;
    late MockScrappingBrowser browser;
    late MockBrowser browserInstance;
    late ScrappingExecutorImpl scrappingExecutor;

    setUp(() {
      creator = MockScrappingCreator();
      browserInstance = MockBrowser();
      browser = MockScrappingBrowser();
      when(() => browser.instance).thenReturn(browserInstance);
      when(() => browser.open()).thenAnswer((_) => Future.value());
      when(() => browser.close()).thenAnswer((_) => Future.value());
      scrappingExecutor = ScrappingExecutorImpl(
        scrappingCreator: creator,
        browser: browser,
      );
    });

    test('deve retornar vazio quando não houver sites válidos', () async {
      final sites = fakePostSites();
      for (final site in sites) {
        when(() => creator.fromSite(site: site))
            .thenThrow(ScrappingCreatorError(''));
      }
      final result = await scrappingExecutor.scrapePosts(sites);
      expect(result, isEmpty);
    });

    test('deve lançar falha quando receber um erro externo', () async {
      final sites = fakePostSites();
      final siteScrapping = MockSiteScrapping();
      when(() => siteScrapping.scrapeData(browser))
          .thenThrow(fakeExternalError());
      when(() => creator.fromSite(site: sites.first)).thenReturn(siteScrapping);

      expect(
        () async => await scrappingExecutor.scrapePosts([sites.first]),
        throwsA(isA<ScrappingFailure>()),
      );
    });

    test('deve executar scrape para os sites válidos', () async {
      final sites = fakePostSites();
      final post = fakePost();
      final siteScrapping = MockSiteScrapping();
      when(() => siteScrapping.scrapeData(browser))
          .thenAnswer((_) => Future.value([post]));
      int countValids = 0;
      for (final site in sites) {
        if (faker.randomGenerator.boolean()) {
          when(() => creator.fromSite(site: site)).thenReturn(siteScrapping);
          countValids++;
        } else {
          when(() => creator.fromSite(site: site))
              .thenThrow(ScrappingCreatorError(''));
        }
      }
      final posts = await scrappingExecutor.scrapePosts([sites.first]);
      expect(posts.length, countValids);
      if (posts.isNotEmpty) {
        verify(() => siteScrapping.scrapeData(browser)).called(countValids);
      } else {
        verifyNever(() => siteScrapping.scrapeData(browser));
      }
    });

    test('deve retornar posts quando houver sites válidos', () async {
      final sites = fakePostSites();
      List<Post> expectedData = [];
      List<MockSiteScrapping> siteScrappings = [];
      for (final site in sites) {
        final siteScrapping = MockSiteScrapping();
        final posts = fakePosts();
        when(() => siteScrapping.scrapeData(browser))
            .thenAnswer((_) => Future.value(posts));
        when(() => creator.fromSite(site: site)).thenReturn(siteScrapping);
        expectedData.addAll(posts);
        siteScrappings.add(siteScrapping);
      }
      final result = await scrappingExecutor.scrapePosts(sites);
      expect(result, isA<List<Post>>());
      expect(result.length, expectedData.length);
      verify(() => browser.open()).called(1);
      verify(() => browser.close()).called(1);
      for (final siteScrapping in siteScrappings) {
        verify(() => siteScrapping.scrapeData(browser)).called(1);
      }
    });
  });
}
