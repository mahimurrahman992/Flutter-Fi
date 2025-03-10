import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/like_provider.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/screens/auth/auth_screen.dart';
import 'package:test_flutter_fi/widgets/comment_section.dart';
import 'package:test_flutter_fi/widgets/gradient_text.dart';

class CustomBlogCard extends StatelessWidget {
  final String blogId;
  final String title;
  final String content;
  final String category;
  final String adminEmail;
  final String fullName;
  final bool isLarge;
  final Timestamp createdAt;

  CustomBlogCard(
      {required this.blogId,
      required this.title,
      required this.content,
      required this.category,
      required this.adminEmail,
      required this.fullName,
      this.isLarge = false,
      required this.createdAt});

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    final theme = Provider.of<ThemeProvider>(context);
    String formattedDate =
        DateFormat('MMMM dd, yyyy, h:mm a').format(createdAt.toDate());
    return Card(
      margin: EdgeInsets.all(16),
      elevation: isLarge ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: theme.isDarkTheme?darkCardColor:lightCardColor, // Main Background: White (#FFFFFF)
      shadowColor: Colors.teal.withOpacity(0.4), // Shadow Color: Teal (#009688)
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with a gradient
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientText(
                  text: title,
                  fontSize: 26,
                  fw: FontWeight.w600,
                ),
                IconButton(
                  icon: Icon(Icons.save,
                      color: Colors.deepPurple), // Button Color: Teal (#009688)
                  onPressed: () async {
                    var user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    } else {
                      var userUid = user.uid;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .update({
                        'savedBlogs': FieldValue.arrayUnion([blogId]),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Blog saved successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Category Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category: $category',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600], // Text Color: Dark Gray (#333333)
                  ),
                ), // Admin Info
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Admin: $fullName',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, // Text Color: Dark Gray (#333333)
                      ),
                    ), SizedBox(height: 10),
            // Display Created At Timestamp
            Text(
              'Published on: $formattedDate', // Display formatted date
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey, // Text Color: Dark Gray (#333333)
                fontStyle: FontStyle.italic,
              ),
            ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            // Content Text
            Text(
              content,
              style: myStyle(17, theme.isDarkTheme?darkPrimaryTextColor:lightprimarytextColor),
            ),
           
            SizedBox(height: 15),
            // Like Button and Likes Counter
            Row(
              children: [
                if (currentUser != null)
                  IconButton(
                    icon: Icon(Icons.thumb_up,
                        color:
                            Colors.deepPurple), // Button Color: Teal (#009688)
                    onPressed: () async {
                      var likeProvider =
                          Provider.of<LikeProvider>(context, listen: false);
                      await likeProvider.likeBlog(blogId);
                    },
                  ),
                if (currentUser == null)
                  Text(
                    'Login to like/comment',
                    style: myStyle(
                        16,
                        theme.isDarkTheme
                            ? darkSecTextColor
                            : lightsectextColor),
                  ),
                SizedBox(width: 10),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(blogId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading likes...');
                    }
                    var blogData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> likes = blogData['likes'] ?? [];

                    return likes.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Liked By',
                                    style: myStyle(
                                        16,
                                        theme.isDarkTheme
                                            ? darkPrimaryTextColor
                                            : lightprimarytextColor,
                                        FontWeight.w600),
                                  ),
                                  content: Container(
                                    width: double.maxFinite,
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: likes.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(likes[index]),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Liked by: ${likes.length}',
                              style: myStyle(
                                  16,
                                 theme.isDarkTheme
                                            ? darkPrimaryTextColor
                                            : lightprimarytextColor),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
            // Comment Section widget
            CommentSection(blogId: blogId),
          ],
        ),
      ),
    );
  }
}
