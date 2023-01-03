extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> get nonNulls {
    return where((element) => element != null).cast<T>();
  }
}
