import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_fi/services/firebase_services.dart';

class UserInteractionsPage extends StatelessWidget {
  final String adminEmail;
final FirebaseService _firebaseService = FirebaseService(); 
  UserInteractionsPage({required this.adminEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Interactions'),
      ),
      body: StreamBuilder(
        // Query blogs created by the current admin
        stream:_firebaseService.getAdminBlogs(adminEmail),
        
        
        
        
        /*FirebaseFirestore.instance
            .collection('blogs')
            .where('adminEmail', isEqualTo: adminEmail)
            .snapshots(),*/
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No blogs available.'));
          }

          var blogs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              var blog = blogs[index];
              var blogData = blog.data() as Map<String, dynamic>;
              String blogId = blog.id; // Get the blogId to fetch the likes

              return BlogTileWithLikes(
                blogId: blogId,  // Pass the blogId
                title: blogData['title'] ?? 'No Title',
                content: blogData['content'] ?? 'No Content',
                category: blogData['category'] ?? 'No Category',
                adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                firebaseService: _firebaseService,
                
              );
            },
          );
        },
      ),
    );
  }
}

class BlogTileWithLikes extends StatelessWidget {
  final String blogId;
  final String title;
  final String content;
  final String category;
  final String adminEmail;
  final FirebaseService firebaseService; // Instance of FirebaseService

  BlogTileWithLikes({
    required this.blogId,
    required this.title,
    required this.content,
    required this.category,
    required this.adminEmail,
    required this.firebaseService, // Initialize FirebaseService
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Text(
              'Admin: $adminEmail',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 10),
            // Like Button
            IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () async {
                await firebaseService.likeBlog(blogId); // Call the likeBlog function from FirebaseService
              },
            ),
            // Displaying the likes for the specific blog
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('blogs').doc(blogId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading likes...');
                }
                var blogData = snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> likes = blogData['likes'] ?? [];

                // Display the list of users who liked the blog
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Liked by:'),
                    for (var userEmail in likes)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          userEmail, // Display the user who liked the blog
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

