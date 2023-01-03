import 'dart:io';

import 'package:supabase/supabase.dart';

import '../../data/picture_creator/file_storage.dart';

class SupabseFileStorage implements FileStorage {
  final SupabaseClient _supabaseClient;

  SupabseFileStorage({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Future<String> upload(File file) async {
    final fileName = file.path.split('/').last;
    final postsBucket = _supabaseClient.storage.from('posts');
    await postsBucket.upload(fileName, file);
    return postsBucket.getPublicUrl(fileName);
  }
}
