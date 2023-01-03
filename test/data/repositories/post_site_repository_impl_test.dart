import 'package:ifba_bot/core/post_site.dart';
import 'package:ifba_bot/data/repositories/sql/sql_post_site.dart';
import 'package:ifba_bot/data/repositories/post_site_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fakers.dart';

class MockPostSiteDatasource extends Mock implements SqlPostSiteDatasource {}

void main() {
  group('Post Site Repository Impl', () {
    late final SqlPostSiteDatasource postSiteDatasource;
    late final PostSiteRepositoryImpl postSiteRepository;

    setUp(() async {
      postSiteDatasource = MockPostSiteDatasource();
      postSiteRepository = PostSiteRepositoryImpl(
        postSiteDatasource: postSiteDatasource,
      );
    });

    test('deve retornar uma lista PostSite', () async {
      final postSites = fakePostSiteModels();
      when(() => postSiteDatasource.getPostSites())
          .thenAnswer((_) async => postSites);
      final result = await postSiteRepository.getAllSites();
      expect(result, isA<List<PostSite>>());
      expect(result.length, postSites.length);
    });
  });
}
