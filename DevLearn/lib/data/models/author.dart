class Author {
  final String id;
  final String username;

  Author({required this.id, required this.username});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      // API trả về `_id` cho author object
      id: json['_id'] ?? '',
      username: json['username'] ?? 'Anonymous',
    );
  }
}
