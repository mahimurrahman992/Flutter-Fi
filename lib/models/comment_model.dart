import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String userName; // Added userName field
  final String commentText;
  final Timestamp timestamp;

  Comment({
    required this.userId,
    required this.userName, // Add userName to the constructor
    required this.commentText,
    required this.timestamp,
  });

  // Convert the Comment object to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName, // Store userName in Firestore
      'comment': commentText,
      'timestamp': timestamp,
    };
  }

  // Create a Comment object from a Map fetched from Firestore
  static Comment fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['user_id'],
      userName: map['user_name'], // Fetch userName from the map
      commentText: map['comment'],
      timestamp: map['timestamp'],
    );
  }
}
