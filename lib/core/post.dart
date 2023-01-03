import 'post_site.dart';

typedef PostPictureUrl = String;

class Post {
  final String title;
  final DateTime publishedAt;
  final PostSite site;
  final String pageUrl;
  PostPictureUrl? pictureUrl;

  Post({
    required this.title,
    required this.publishedAt,
    required this.site,
    required this.pageUrl,
    this.pictureUrl,
  });

  bool get hasPicture => pictureUrl != null;

  Post copyWithPictureUrl(PostPictureUrl pictureUrl) {
    return Post(
      title: title,
      publishedAt: publishedAt,
      site: site,
      pageUrl: pageUrl,
      pictureUrl: pictureUrl,
    );
  }

  @override
  String toString() {
    return 'Post(title: $title, publishedAt: $publishedAt, site: $site, pageUrl: $pageUrl)';
  }
}
