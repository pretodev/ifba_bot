import 'post.dart';
import 'post_site.dart';

abstract class ScrappingExecutor {
  Future<List<Post>> scrapePosts(List<PostSite> sites);
}
