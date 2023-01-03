abstract class Failure implements Exception {
  String get message;
}

class PostRepositoryFailure implements Failure {
  @override
  final String message;

  PostRepositoryFailure(this.message);
}

class ScrappingFailure implements Failure {
  @override
  final String message;

  ScrappingFailure(this.message);
}

class PostPictureCreatorFailure implements Failure {
  @override
  final String message;

  PostPictureCreatorFailure(this.message);
}
