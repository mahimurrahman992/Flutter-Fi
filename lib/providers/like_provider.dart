import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeProvider with ChangeNotifier {
  // This function will handle liking a blog
  Future<void> likeBlog(String blogId) async {
    // Get the current logged-in user
    var user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      var userEmail = user.email;

      try {
        // If user is logged in, add their email to the likes array in Firestore
        await FirebaseFirestore.instance.collection('blogs').doc(blogId).update({
          'likes': FieldValue.arrayUnion([userEmail]) // Add user's email to the likes array
        });

        notifyListeners(); // Notify listeners to update UI after the like action
      } catch (e) {
        print("Error adding like: $e");
      }
    } else {
      print('No user logged in');
    }
  }
}
