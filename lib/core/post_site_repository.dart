import 'post_site.dart';

abstract class PostSiteRepository {
  Future<List<PostSite>> getAllSites();
}
