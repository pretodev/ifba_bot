import 'dart:io';

abstract class FileStorage {
  Future<String> upload(File file);
}
