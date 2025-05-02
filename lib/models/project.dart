import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String title;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;

  // Use const constructor for immutability (optional)
  const Project({
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  // Factory method to create a Project from Firestore data (Map)
  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
      title: data['title'] as String? ?? '', // Null-safe default for missing data
      description: data['description'] as String? ?? '',
      status: data['status'] as String? ?? '',
      startDate: _convertTimestampToDateTime(data['start_date']),
      endDate: _convertTimestampToDateTime(data['end_date']),
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  // Helper method to convert Firestore Timestamp to DateTime
  static DateTime _convertTimestampToDateTime(Timestamp? timestamp) {
    return timestamp?.toDate() ?? DateTime.now(); // Default to current time if null
  }

  // Convert Project object to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'start_date': Timestamp.fromDate(startDate),
      'end_date': Timestamp.fromDate(endDate),
      'imageUrl': imageUrl,
    };
  }
}
