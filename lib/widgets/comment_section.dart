import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/models/comment_model.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'custom_textfield.dart'; // Ensure CustomTextField is imported
import 'package:test_flutter_fi/providers/comment_provider.dart';

class CommentSection extends StatefulWidget {
  final String blogId;

  CommentSection({required this.blogId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  bool _isExpanded = false; // Track whether comments are expanded or not

  // Submit comment to Firestore
  Future<void> _submitComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Fetch the user's fullName from the 'users' collection using their UID
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          
          if (userDoc.exists) {
            String fullName = userDoc['fullName']; // Assuming the field is named 'fullName'

            // Submit the comment along with the user's name to Firestore
            await FirebaseFirestore.instance.collection('blogs')
                .doc(widget.blogId)  // Assuming the blog ID is passed through the widget
                .collection('comments')
                .add({
                  'user_id': user.uid,
                  'user_name': fullName,  // Store the fullName of the commenter
                  'comment': commentText,
                  'timestamp': FieldValue.serverTimestamp(),
                });

            // Clear the input field after submitting the comment
            _commentController.clear();
          } else {
            // Handle the case where the user document doesn't exist
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User not found')),
            );
          }
        } catch (e) {
          // Handle any errors that occur during fetching the user's name or submitting the comment
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit comment')),
          );
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomTextField for adding a comment
        FirebaseAuth.instance.currentUser != null
            ? Padding(
              padding: const EdgeInsets.only(right: 500),
              child: CustomTextField(
                  controller: _commentController,
                  labelText: 'Add a Comment',
                  hintText: 'Type your comment here...',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a comment';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _submitComment,
                  ),
                ),
            )
            : SizedBox.shrink(),

        // Display the list of comments using StreamBuilder for real-time updates
        Consumer<CommentProvider>(
          builder: (context, commentProvider, child) {
            
            return StreamBuilder<List<Comment>>(
              stream: commentProvider.fetchComments(widget.blogId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();  // Show loading indicator
                }

                if (snapshot.hasError) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No comments yet.');
                }

                List<Comment> comments = snapshot.data!;

                // Only show the first 2 comments initially
                List<Comment> displayedComments = _isExpanded ? comments : comments.take(2).toList();

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: displayedComments.length,
                      itemBuilder: (context, index) {
                        Comment comment = displayedComments[index];
                         String formattedDate = DateFormat('MMMM dd, yyyy,  h:mm a').format(comment.timestamp.toDate()); // Format the date as desired
                        return Column(
                          children: [
                            ListTile(
                              title: Text(comment.commentText),
                              subtitle: Text(
                                'By: ${comment.userName}  •  ${formattedDate}',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            Divider(height: 2,indent: 50,endIndent: 50,)
                          ],
                        );
                      },
                    ),
                    if (comments.length > 2)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Show less' : 'Show more',
                          style: myStyle(16, theme.isDarkTheme ? darkSecTextColor : lightsectextColor),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
