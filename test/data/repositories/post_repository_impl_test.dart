import 'package:ifba_bot/core/failures.dart';
import 'package:ifba_bot/data/repositories/sql/sql_post.dart';
import 'package:ifba_bot/data/repositories/sql/sql_post_site.dart';
import 'package:ifba_bot/data/repositories/post_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fakers.dart';

class MockPostDatasource extends Mock implements SqlPostDatasource {}

class MockPostSiteDatasource extends Mock implements SqlPostSiteDatasource {}

void main() {
  group("PostRepositoryImpl", () {
    late SqlPostDatasource postDatasource;
    late SqlPostSiteDatasource postSiteDatasource;
    late PostRepositoryImpl postRepositoryImpl;

    setUp(() {
      postDatasource = MockPostDatasource();
      postSiteDatasource = MockPostSiteDatasource();
      postRepositoryImpl = PostRepositoryImpl(
        postDatasource: postDatasource,
        postSiteDatasource: postSiteDatasource,
      );
      registerFallbackValue(fakePostModel());
    });

    test(
      "deve retorna falso quando não existir post salvo",
      () async {
        final post = fakePost();
        when(() => postDatasource.getPostFromUrl(post.pageUrl))
            .thenAnswer((_) async => null);
        final result = await postRepositoryImpl.exists(post);
        expect(result, false);
      },
    );

    test(
      "deve retorna verdadeiro quando existir post salvo",
      () async {
        final model = fakePostModel();
        final post = fakePost();
        when(() => postDatasource.getPostFromUrl(post.pageUrl))
            .thenAnswer((_) async => model);
        final result = await postRepositoryImpl.exists(post);
        expect(result, true);
      },
    );

    test(
      "deve lançar falha quando tentar salvar com site inexistente na base de dadoss",
      () async {
        final post = fakePost();
        when(() => postSiteDatasource.getPostSite(post.site.key))
            .thenAnswer((_) async => null);
        expect(
          () => postRepositoryImpl.save(post),
          throwsA(isA<PostRepositoryFailure>()),
        );
      },
    );

    test(
      "deve salvar post",
      () async {
        final post = fakePost();
        final postSiteModel = fakePostSiteModel();
        when(() => postSiteDatasource.getPostSite(post.site.key))
            .thenAnswer((_) async => postSiteModel);
        when(() => postDatasource.insertPost(any()))
            .thenAnswer((_) => Future.value());
        await postRepositoryImpl.save(post);
        verify(() => postDatasource.insertPost(any())).called(1);
      },
    );
  });
}
