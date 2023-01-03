import 'dart:io';

class PictureCreatorArgs {
  final String title;
  final String date;
  final String origin;
  final String siteKey;
  PictureCreatorArgs({
    required this.title,
    required this.date,
    required this.origin,
    required this.siteKey,
  });
}

abstract class PictureCreator {
  Future<File> run(PictureCreatorArgs args);
}
