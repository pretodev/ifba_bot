import '../../../core/post_site.dart';

class SqlPostSiteModel {
  final int? id;
  final String key;
  final String name;
  final String url;

  SqlPostSiteModel({
    this.id,
    required this.key,
    required this.name,
    required this.url,
  });

  factory SqlPostSiteModel.fromPost(PostSite postSite) {
    return SqlPostSiteModel(
      key: postSite.key,
      name: postSite.name,
      url: postSite.url,
    );
  }

  PostSite toPostSite() {
    return PostSite(
      key: key,
      name: name,
      url: url,
    );
  }
}

abstract class SqlPostSiteDatasource {
  Future<List<SqlPostSiteModel>> getPostSites();

  Future<SqlPostSiteModel?> getPostSite(String key);
}
