import '../../../core/post.dart';
import '../../../core/post_site.dart';

class SqlPostModel {
  final int? id;
  final String url;
  final String title;
  final DateTime publishedAt;
  final int siteId;

  SqlPostModel({
    this.id,
    required this.url,
    required this.title,
    required this.publishedAt,
    required this.siteId,
  });

  factory SqlPostModel.fromPost(int siteId, Post post) {
    return SqlPostModel(
      url: post.pageUrl,
      title: post.title,
      publishedAt: post.publishedAt,
      siteId: siteId,
    );
  }

  Post toPost(PostSite site) {
    return Post(
      title: title,
      publishedAt: publishedAt,
      pageUrl: url,
      site: site,
    );
  }
}

abstract class SqlPostDatasource {
  Future<SqlPostModel?> getPostFromUrl(String url);

  Future<void> insertPost(SqlPostModel post);
}
