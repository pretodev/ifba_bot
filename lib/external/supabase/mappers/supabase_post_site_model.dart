import '../../../data/repositories/sql/sql_post_site.dart';

class SupabasePostSiteModel extends SqlPostSiteModel {
  SupabasePostSiteModel({
    super.id,
    required super.key,
    required super.name,
    required super.url,
  });

  factory SupabasePostSiteModel.fromModel(SqlPostSiteModel model) {
    return SupabasePostSiteModel(
      id: model.id,
      key: model.key,
      name: model.name,
      url: model.url,
    );
  }

  factory SupabasePostSiteModel.fromMap(Map<String, dynamic> map) {
    return SupabasePostSiteModel(
      id: map['id'] as int?,
      key: map['key'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'url': url,
    };
  }
}
