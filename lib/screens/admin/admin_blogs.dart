

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:test_flutter_fi/screens/admin/view_all_blogs.dart';
import 'package:test_flutter_fi/services/firebase_services.dart';

class AdminBlogsPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService(); // Initialize FirebaseService
  final String adminEmail = FirebaseAuth.instance.currentUser!.email!; // Get the current logged-in admin's email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Blogs'),
      ),
      body: StreamBuilder(
        stream: _firebaseService.getAdminBlogs(adminEmail), // Fetch admin's blogs
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No blogs uploaded by this admin.'));
          }

          var blogs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              var blog = blogs[index];
              var blogData = blog.data() as Map<String, dynamic>;

              return BlogTile(
                blogId: blog.id, // Pass the blogId
                title: blogData['title'] ?? 'No Title',
                content: blogData['content'] ?? 'No Content',
                category: blogData['category'] ?? 'No Category',
                adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
              );
            },
          );
        },
      ),
    );
  }
}