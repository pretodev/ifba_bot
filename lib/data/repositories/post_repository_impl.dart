import '../../core/failures.dart';
import '../../core/post.dart';
import '../../core/post_datasource.dart';
import 'sql/sql_post.dart';
import 'sql/sql_post_site.dart';

class PostRepositoryImpl implements PostRepository {
  final SqlPostDatasource _postDatasource;
  final SqlPostSiteDatasource _postSiteDatasource;

  PostRepositoryImpl({
    required SqlPostDatasource postDatasource,
    required SqlPostSiteDatasource postSiteDatasource,
  })  : _postDatasource = postDatasource,
        _postSiteDatasource = postSiteDatasource;

  @override
  Future<bool> exists(Post post) async {
    final data = await _postDatasource.getPostFromUrl(post.pageUrl);
    return data != null;
  }

  @override
  Future<void> save(Post post) async {
    final site = await _postSiteDatasource.getPostSite(post.site.key);
    if (site == null) {
      throw PostRepositoryFailure('Site não encontrado');
    }
    final model = SqlPostModel.fromPost(site.id!, post);
    await _postDatasource.insertPost(model);
  }
}
