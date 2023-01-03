import 'package:puppeteer/puppeteer.dart';

import '../../../core/post.dart';
import '../../../core/post_site.dart';
import '../../../data/scrapping/scrapping.dart';
import '../../../data/scrapping/scrapping_browser.dart';
import '../pupperteer_browser.dart';

class IfbaTypeAScrapping implements Scrapping {
  final PostSite site;

  IfbaTypeAScrapping({
    required this.site,
  });

  static const _scrappingJsCode = r'''() => {
    const articles = document.querySelectorAll('#content-core article');
    const data = [];
    articles.forEach(articleEl => {
      const infosEl = articleEl.querySelectorAll('.documentByLine .summary-view-icon')
      const dateStr = infosEl[0].innerText.trim();
      const date = dateStr.split('/').map(d => parseInt(d, 10));
      const hourStr = infosEl[1].innerText.trim();
      const hour = hourStr.split('h').map(h => parseInt(h, 10));
      const dateObj = new Date(date[2], date[1] - 1, date[0], hour[0], hour[1]);
      const keywordsEl = articleEl.querySelectorAll('.keywords span');
      const keywords = [];
      keywordsEl.forEach(keywordEl => {
        keywords.push(keywordEl.innerText.trim());
      });
      data.push({
        title: articleEl.querySelector('.tileContent h2 a').innerText,
        pageUrl: articleEl.querySelector('.tileContent h2 a').getAttribute('href').trim(),
        date: dateObj.toJSON(),
        keywords: keywords,
      });
    });
    return data;
  }''';

  @override
  Future<List<Post>> scrapeData(ScrappingBrowser browser) async {
    final page = await (browser as PupperteerBrowser).instance.newPage();
    await page.goto(site.url, wait: Until.domContentLoaded);
    final data = await page.evaluate<List>(_scrappingJsCode);
    final posts = data
        .map(
          (item) => Post(
            title: item['title'],
            pageUrl: item['pageUrl'],
            publishedAt: DateTime.parse(item['date']),
            site: site,
          ),
        )
        .toList();
    await page.close();
    return posts;
  }
}
