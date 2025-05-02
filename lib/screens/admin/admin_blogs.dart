

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/admin/view_all_blogs.dart';
import 'package:myflutterfi/services/firebase_services.dart';
import 'package:provider/provider.dart';


class AdminBlogsPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService(); // Initialize FirebaseService
  final String adminEmail = FirebaseAuth.instance.currentUser!.email!; // Get the current logged-in admin's email

  @override
  Widget build(BuildContext context) {
     final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(backgroundColor: theme.isDarkTheme?Colors.black:lightBackgroundColor,
      appBar: AppBar(backgroundColor: theme.isDarkTheme?Colors.black:lightBackgroundColor,
        title: Text('Admin Blogs'), automaticallyImplyLeading: false, // This removes the back button
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