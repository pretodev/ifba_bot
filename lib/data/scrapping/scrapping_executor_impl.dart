import '../../core/failures.dart';
import '../../core/post.dart';
import '../../core/post_site.dart';
import '../../core/scrapping_executor.dart';
import '../../external/error.dart';
import 'scrapping_browser.dart';
import 'scrapping_creator.dart';
import 'scrapping.dart';

class ScrappingExecutorImpl implements ScrappingExecutor {
  final ScrappingCreator scrappingCreator;
  final ScrappingBrowser browser;

  ScrappingExecutorImpl({
    required this.scrappingCreator,
    required this.browser,
  });

  Scrapping? _getScrapping(PostSite site) {
    try {
      return scrappingCreator.fromSite(site: site);
    } on ScrappingCreatorError {
      return null;
    }
  }

  @override
  Future<List<Post>> scrapePosts(List<PostSite> sites) async {
    try {
      final scrappings = sites //
          .map(_getScrapping)
          .where((element) => element != null)
          .cast<Scrapping>();
      if (scrappings.isEmpty) return [];
      await browser.open();
      final postLists = await Future.wait(
        scrappings
            .map((scrapping) async => await scrapping.scrapeData(browser)),
      );
      await browser.close();
      return postLists.expand((post) => post).toList();
    } on ExternalError catch (error) {
      throw ScrappingFailure(error.message);
    }
  }
}
