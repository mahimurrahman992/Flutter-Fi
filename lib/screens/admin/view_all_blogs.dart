import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_fi/services/firebase_services.dart';

class ViewBlogsPage extends StatelessWidget {
   final FirebaseService _firebaseService = FirebaseService(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Blogs'),
      ),
      body: StreamBuilder(
        stream:  _firebaseService.getBlogs(),                                    //FirebaseFirestore.instance.collection('blogs').snapshots(),
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

              // Ensure that the data is not null before accessing
              String title = blogData['title'] ?? 'No Title'; // Default value if title is null
              String content = blogData['content'] ?? 'No Content'; // Default value if content is null
              String category = blogData['category'] ?? 'No Category'; // Default value if category is null
              String adminEmail = blogData['adminEmail'] ?? 'No Admin'; // Default value if adminEmail is null

              return BlogTile(
                blogId: blog.id, 
                title: title,
                content: content,
                category: category,
                adminEmail: adminEmail,
              );
            },
          );
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String blogId; // Add blogId as a parameter
  final String title;
  final String content;
  final String category;
  final String adminEmail;

  // Include blogId in the constructor
  BlogTile({
    required this.blogId,
    required this.title,
    required this.content,
    required this.category,
    required this.adminEmail,
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
            // Like Button
            IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () async {
                var userEmail = FirebaseAuth.instance.currentUser?.email;
                if (userEmail != null) {
                  await FirebaseFirestore.instance.collection('blogs').doc(blogId).update({
                    'likes': FieldValue.arrayUnion([userEmail]) // Add user's email to the likes array
                  });
                }
              },
            ),
            // Display the likes
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('blogs').doc(blogId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading likes...');
                }
                var blogData = snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> likes = blogData['likes'] ?? [];
                return Text('Liked by: ${likes.join(', ')}');
              },
            ),
          ],
        ),
      ),
    );
  }
}


