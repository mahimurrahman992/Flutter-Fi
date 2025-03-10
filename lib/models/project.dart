import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String title;
  String description;
  String status;
  Timestamp startDate;
  Timestamp endDate;
  String imageUrl;

  Project({
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
      title: data['title'],
      description: data['description'],
      status: data['status'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'imageUrl': imageUrl,
    };
  }
}
