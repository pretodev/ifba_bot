import 'package:puppeteer/puppeteer.dart';

import '../../../core/post.dart';
import '../../../core/post_site.dart';
import '../../../data/scrapping/scrapping.dart';
import '../../../data/scrapping/scrapping_browser.dart';
import '../pupperteer_browser.dart';

const _scrappingJsCode = r'''() => {
  const articles = document.querySelectorAll('#content-core .item');
  const data = [];
  articles.forEach(articleEl => {
    const dateHourStr = articleEl.querySelector('span[property="rnews:datePublished"]').innerText.trim();
    const DateHourElements = dateHourStr.split(' ');
    const date = DateHourElements[0].split('/').map(d => parseInt(d, 10));
    const hour = DateHourElements[1].split('h').map(h => parseInt(h, 10));
    const dateObj = new Date(date[2], date[1] - 1, date[0], hour[0], hour[1]);
    data.push({
      title: articleEl.querySelector('h2.headline a').innerText,
      pageUrl: articleEl.querySelector('h2.headline a').getAttribute('href').trim(),
      date: dateObj.toJSON(),
    });
  });
  return data;
}''';

class IfbaTypeBScrapping implements Scrapping {
  final PostSite site;

  IfbaTypeBScrapping({
    required this.site,
  });

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
