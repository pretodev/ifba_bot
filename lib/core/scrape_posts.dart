import 'dart:async';

import 'scrapping_executor.dart';
import 'post_site_repository.dart';
import 'send_post.dart';

class ScrapePosts {
  final SendPost sendPost;
  final ScrappingExecutor scrappingExecutor;
  final PostSiteRepository postSiteRepository;

  static const maxNewPosts = 5;

  ScrapePosts({
    required this.sendPost,
    required this.scrappingExecutor,
    required this.postSiteRepository,
  });

  Future<void> call() async {
    final sites = await postSiteRepository.getAllSites();
    final posts = await scrappingExecutor.scrapePosts(sites);
    posts.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    final newPosts = posts.take(maxNewPosts).toList().reversed;
    for (final post in newPosts) {
      await sendPost(post);
    }
  }
}
