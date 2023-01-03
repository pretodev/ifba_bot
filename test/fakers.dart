import 'package:faker/faker.dart';
import 'package:ifba_bot/core/post.dart';
import 'package:ifba_bot/core/post_site.dart';
import 'package:ifba_bot/data/repositories/sql/sql_post.dart';
import 'package:ifba_bot/data/repositories/sql/sql_post_site.dart';
import 'package:ifba_bot/external/error.dart';

Post fakePost() {
  return Post(
    title: faker.randomGenerator.string(10),
    publishedAt: faker.date.dateTime(),
    site: PostSite(
      key: faker.guid.guid(),
      name: faker.randomGenerator.string(10),
      url: faker.internet.httpUrl(),
    ),
    pageUrl: faker.internet.httpUrl(),
  );
}

SqlPostModel fakePostModel() {
  return SqlPostModel(
    title: faker.randomGenerator.string(10),
    publishedAt: faker.date.dateTime(),
    siteId: faker.randomGenerator.integer(100),
    url: faker.internet.httpUrl(),
    id: faker.randomGenerator.integer(100),
  );
}

List<Post> fakePosts([int max = 5]) {
  return List.generate(
    faker.randomGenerator.integer(max, min: 1),
    (_) => fakePost(),
  );
}

List<PostSite> fakePostSites() {
  return List.generate(
    faker.randomGenerator.integer(5, min: 1),
    (_) => PostSite(
      key: faker.guid.guid(),
      name: faker.lorem.word(),
      url: faker.internet.httpUrl(),
    ),
  );
}

SqlPostSiteModel fakePostSiteModel() {
  return SqlPostSiteModel(
    id: faker.randomGenerator.integer(100),
    key: faker.guid.guid(),
    name: faker.lorem.word(),
    url: faker.internet.httpUrl(),
  );
}

List<SqlPostSiteModel> fakePostSiteModels() {
  return List.generate(
    faker.randomGenerator.integer(faker.randomGenerator.integer(20)),
    (_) => fakePostSiteModel(),
  );
}

ExternalError fakeExternalError() {
  return ExternalError(
    message: faker.lorem.sentence(),
    service: faker.lorem.word(),
    stackTrace: StackTrace.current,
  );
}
