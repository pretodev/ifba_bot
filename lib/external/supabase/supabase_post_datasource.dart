import 'package:supabase/supabase.dart';

import '../../data/repositories/sql/sql_post.dart';
import 'mappers/supabase_post_model.dart';

class SupabasePostDatasource implements SqlPostDatasource {
  static const String _tableName = 'post';

  final SupabaseClient _supabaseClient;

  SupabasePostDatasource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Future<SqlPostModel?> getPostFromUrl(String url) async {
    final postData = await _supabaseClient //
        .from(_tableName)
        .select()
        .eq('url', url);
    final posts = postData as Iterable;
    if (posts.isEmpty) {
      return null;
    }
    return SupabasePostModel.fromMap(posts.first);
  }

  @override
  Future<void> insertPost(SqlPostModel post) async {
    await _supabaseClient
        .from(_tableName)
        .insert(SupabasePostModel.fromModel(post).toMap());
  }
}
