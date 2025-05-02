import 'dart:convert';

class Blog {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;

  // Use `const` constructor if the Blog class is not likely to change once created
  const Blog({
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
      id: map['id'] as String? ?? '', // Use `as String?` for better type handling
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      category: map['category'] as String? ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(), // Gracefully handle null or invalid date parsing
    );
  }

  // Convert a Blog object into a JSON string
  String toJson() => json.encode(toMap());

  // Create a Blog object from a JSON string
  factory Blog.fromJson(String source) {
    return Blog.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
