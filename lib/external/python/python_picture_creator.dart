import 'dart:io';

import '../../data/picture_creator/picture_creator.dart';
import '../error.dart';
import 'python_run.dart';

class PythonPictureCreator implements PictureCreator {
  final String scriptPath;

  final _run = PythonRun();

  PythonPictureCreator({
    required this.scriptPath,
  });

  @override
  Future<File> run(PictureCreatorArgs args) async {
    final result = await _run(scriptPath, [
      '--image',
      args.siteKey,
      '--date',
      args.date,
      '--origin',
      args.origin,
      '--title',
      args.title,
    ]);
    if (result.isError) {
      throw ExternalError(
        service: 'Python',
        message: result.data,
        stackTrace: StackTrace.current,
      );
    }
    return File(result.data);
  }
}
