import '../../core/post.dart';
import 'scrapping_browser.dart';

abstract class Scrapping {
  Future<List<Post>> scrapeData(ScrappingBrowser browser);
}
