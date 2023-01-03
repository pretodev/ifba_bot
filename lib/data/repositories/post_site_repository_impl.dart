import '../../core/post_site.dart';
import '../../core/post_site_repository.dart';
import 'sql/sql_post_site.dart';

class PostSiteRepositoryImpl extends PostSiteRepository {
  final SqlPostSiteDatasource _postSiteDatasource;

  PostSiteRepositoryImpl({
    required SqlPostSiteDatasource postSiteDatasource,
  }) : _postSiteDatasource = postSiteDatasource;

  @override
  Future<List<PostSite>> getAllSites() async {
    final models = await _postSiteDatasource.getPostSites();
    return models.map((model) => model.toPostSite()).toList();
  }
}
