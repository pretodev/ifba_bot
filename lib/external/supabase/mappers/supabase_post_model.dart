import '../../../data/repositories/sql/sql_post.dart';

class SupabasePostModel extends SqlPostModel {
  SupabasePostModel({
    super.id,
    required super.url,
    required super.title,
    required super.publishedAt,
    required super.siteId,
  });

  factory SupabasePostModel.fromModel(SqlPostModel post) {
    return SupabasePostModel(
      url: post.url,
      title: post.title,
      publishedAt: post.publishedAt,
      siteId: post.siteId,
    );
  }

  factory SupabasePostModel.fromMap(Map<String, dynamic> map) {
    return SupabasePostModel(
      id: map['id'] as int?,
      url: map['url'] as String,
      title: map['title'] as String,
      publishedAt: DateTime.parse(map['published_at'] as String),
      siteId: map['site_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'url': url,
      'title': title,
      'published_at': publishedAt.toIso8601String(),
      'site_id': siteId,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
