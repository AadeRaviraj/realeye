class Subtopic {
  final int id;
  final String title;
  final String videoUrl;
  final bool completed;

  Subtopic({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.completed,
  });

  factory Subtopic.fromJson(Map<String, dynamic> json) {
    return Subtopic(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'] ?? "",
      completed: json['completed'] ?? false,
    );
  }
}