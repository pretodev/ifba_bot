import 'package:supabase/supabase.dart';

import '../../data/repositories/sql/sql_post_site.dart';
import 'mappers/supabase_post_site_model.dart';

class SupabasePostSiteDatasource implements SqlPostSiteDatasource {
  static const postSiteTable = 'post_site';

  final SupabaseClient _supabaseClient;

  SupabasePostSiteDatasource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Future<List<SqlPostSiteModel>> getPostSites() async {
    final data = await _supabaseClient.from(postSiteTable).select();
    final posts = data as Iterable;
    return posts.map((map) => SupabasePostSiteModel.fromMap(map)).toList();
  }

  @override
  Future<SqlPostSiteModel?> getPostSite(String key) async {
    final data =
        await _supabaseClient.from(postSiteTable).select().eq('key', key);
    final posts = data as Iterable;
    if (posts.isEmpty) {
      return null;
    }
    return SupabasePostSiteModel.fromMap(posts.first);
  }
}
