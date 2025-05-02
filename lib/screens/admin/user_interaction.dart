import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/services/firebase_services.dart';
import 'package:provider/provider.dart';

class UserInteractionsPage extends StatelessWidget {
  final String adminEmail;
  final FirebaseService _firebaseService = FirebaseService();

  UserInteractionsPage({required this.adminEmail});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
        title: Text('User Interactions'),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: StreamBuilder(
        // Query blogs created by the current admin
        stream: _firebaseService.getAdminBlogs(adminEmail),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No blogs available.'));
          }

          var blogs = snapshot.data!.docs;

          // Filter blogs that have at least one like
          var blogsWithLikes = blogs.where((blog) {
            var blogData = blog.data() as Map<String, dynamic>;
            List<dynamic> likes = blogData['likes'] ?? [];
            return likes.isNotEmpty; // Only show blogs with likes
          }).toList();

          if (blogsWithLikes.isEmpty) {
            return Center(child: Text('No blogs with likes yet.'));
          }

          return ListView.builder(
            itemCount: blogsWithLikes.length,
            itemBuilder: (context, index) {
              var blog = blogsWithLikes[index];
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
  final FirebaseService firebaseService;

  BlogTileWithLikes({
    required this.blogId,
    required this.title,
    required this.content,
    required this.category,
    required this.adminEmail,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

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
            // Like Button with Count
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () async {
                    await firebaseService.likeBlog(blogId); // Call the likeBlog function from FirebaseService
                  },
                ),
                // Like count display
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(blogId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Likes: 0');
                    }

                    var blogData = snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> likes = blogData['likes'] ?? [];
                    return Text('Likes: ${likes.length}');
                  },
                ),
              ],
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Liked by:'),
                    for (var user in likes)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '${user['fullName']} (${user['email']})', // Display the user's fullName and email
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
