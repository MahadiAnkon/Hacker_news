class News {
  final String title;
  final String author;
  final DateTime time;
  final String? text;
  final int commentsCount;
  final List<Map<String, dynamic>> comments;

  News({
    required this.title,
    required this.author,
    required this.time,
    this.text,
    required this.commentsCount,
    required this.comments,
  });
}
