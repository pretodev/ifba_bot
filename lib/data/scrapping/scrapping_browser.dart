abstract class ScrappingBrowser {
  Future<void> open();

  Future<void> close();

  get instance;
}
