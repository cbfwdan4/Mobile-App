class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] ?? json['content'] ?? 'Keep pushing forward, you are doing great!',
      author: json['a'] ?? json['author'] ?? 'Campus Connect Team',
    );
  }
}
