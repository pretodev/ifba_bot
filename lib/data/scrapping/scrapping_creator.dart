import '../../core/post_site.dart';
import 'scrapping.dart';

class ScrappingCreatorError implements Exception {
  ScrappingCreatorError(this.message);

  final String message;

  @override
  String toString() => 'ScrappingCreatorError(message: $message)';
}

abstract class ScrappingCreator {
  Scrapping fromSite({
    required PostSite site,
  });
}
