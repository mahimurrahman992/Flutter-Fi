import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get all blogs (or filter by category)
  Stream<QuerySnapshot> getBlogs({String? category}) {
    if (category != null && category != 'All') {
      return FirebaseFirestore.instance
          .collection('blogs')
          .where('category', isEqualTo: category)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection('blogs').snapshots();
    }
  }
  
 Future<void> addCategory(String category) async {
    try {
      await _firestore.collection('categories').add({
        'name': category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding category: $e");
      rethrow;
    }
  }
  // Function to get blogs by a specific admin's email
  Stream<QuerySnapshot> getAdminBlogs(String adminEmail) {
    return FirebaseFirestore.instance
        .collection('blogs')
        .where('adminEmail', isEqualTo: adminEmail)
        .snapshots();
  }

  // Function to create a new blog
  Future<void> createBlog({
    required String title,
    required String content,
    required String category,
    required String adminEmail,
  required String fullName, 
  }) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').add({
        'title': title,
        'content': content,
        'category': category,
        'adminEmail': adminEmail,
        'fullName': fullName,  // Store fullName in the 'blogs' collection
        'createdAt': Timestamp.now(),
        'likes': [], // Initialize likes as an empty list
      });
    } catch (e) {
      print('Error creating blog: $e');
    }
  }
  // Function to get categories
  Stream<List<String>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }
  // Function to like a blog (add the user's email to the likes array)
  Future<void> likeBlog(String blogId) async {
    try {
      var userEmail = FirebaseAuth.instance.currentUser?.displayName;
      if (userEmail != null) {
        await FirebaseFirestore.instance.collection('blogs').doc(blogId).update({
          'likes': FieldValue.arrayUnion([userEmail]) // Add the user's email to the likes array
        });
      }
    } catch (e) {
      print('Error liking blog: $e');
    }
  }

}
