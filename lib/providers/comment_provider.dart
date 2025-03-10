import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter_fi/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  // Fetch comments from Firestore in real-time
  Stream<List<Comment>> fetchComments(String blogId) {
    return FirebaseFirestore.instance
        .collection('blogs')
        .doc(blogId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return Comment.fromMap(doc.data());
          }).toList();
        });
  }

  // Submit comment to Firestore
  Future<void> submitComment(String blogId, String commentText) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's fullName from the 'users' collection using their UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String fullName = userDoc['fullName']; // Assuming the field is named 'fullName'

          // Add the comment along with the user's fullName to Firestore
          await FirebaseFirestore.instance.collection('blogs')
              .doc(blogId)
              .collection('comments')
              .add({
                'user_id': user.uid,
                'user_name': fullName, // Store fullName of the commenter
                'comment': commentText,
                'timestamp': FieldValue.serverTimestamp(),
              });
        }
      }
    } catch (e) {
      print('Error submitting comment: $e');
    }
  }
}
