class PostSite {
  final String key;
  final String url;
  final String name;

  PostSite({
    required this.key,
    required this.url,
    required this.name,
  });

  @override
  String toString() => 'PostSite(id: $key, url: $url, name: $name)';
}
