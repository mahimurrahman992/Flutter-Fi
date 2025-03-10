import 'dart:convert';

class Blog {
  late final String id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
  });

  // Convert a Blog object into a map (for Firestore or SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a Blog object from a map (from Firestore or SQLite)
  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  // Convert a Blog object into a JSON string
  String toJson() => json.encode(toMap());

  // Create a Blog object from a JSON string
  factory Blog.fromJson(String source) => Blog.fromMap(json.decode(source));
}

