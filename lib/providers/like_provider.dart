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
      var userId = user.uid;

      try {
        // Fetch the user's fullName from the 'users' collection using their UID
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (userDoc.exists) {
          String fullName =
              userDoc['fullName']; // Assuming the field is named 'fullName'
 String avatarUrl =
              userDoc['avatarUrl'];
          // If user is logged in, add their email and fullName to the likes array in Firestore
          await FirebaseFirestore.instance
              .collection('blogs')
              .doc(blogId)
              .update({
                'likes': FieldValue.arrayUnion([
                  {
                    'email': userEmail,
                    'fullName': fullName,
                    'blogId': blogId,
                    'avatarUrl':avatarUrl
                  }, // Store the user's email and fullName as a map
                ]),
              });

          notifyListeners(); // Notify listeners to update UI after the like action
        } else {
          print('User data not found');
        }
      } catch (e) {
        print("Error adding like: $e");
      }
    } else {
      print('No user logged in');
    }
  }
}
