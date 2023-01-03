import 'dart:io';

String getCurrentPath() {
  final currentDir = Platform.script.toFilePath().split('/');
  currentDir.removeLast();
  return currentDir.join('/');
}
