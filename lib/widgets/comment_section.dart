import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/models/comment_model.dart';
import 'package:myflutterfi/providers/comment_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/features_screeen/developers/user_profile_screen.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          // Fetch the user's fullName and avatarUrl from the 'users' collection using their UID
          DocumentSnapshot userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (userDoc.exists) {
            String fullName =
                userDoc['fullName']; // Assuming the field is named 'fullName'
            String avatarUrl =
                userDoc['avatarUrl'] ??
                'https://www.example.com/default-avatar.png';

            // Submit the comment along with the user's name and avatarUrl to Firestore
            await FirebaseFirestore.instance
                .collection('blogs')
                .doc(
                  widget.blogId,
                ) // Assuming the blog ID is passed through the widget
                .collection('comments')
                .add({
                  'user_id': user.uid,
                  'user_name': fullName, // Store the fullName of the commenter
                  'comment': commentText,
                  'timestamp': FieldValue.serverTimestamp(),
                  'avatarUrl': avatarUrl, // Store the avatarUrl in Firestore
                });

            // Clear the input field after submitting the comment
            _commentController.clear();
          } else {
            // Handle the case where the user document doesn't exist
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('User not found')));
          }
        } catch (e) {
          // Handle any errors that occur during fetching the user's name or submitting the comment
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to submit comment')));
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust input field and comments layout based on screen size
    double fontSize = screenWidth < 600 ? 14 : 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomTextField for adding a comment
        FirebaseAuth.instance.currentUser != null
            ? Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                  return SpinKitRipple(
                    color: Color.fromARGB(
                      255,
                      210,
                      91,
                      212,
                    ), // You can customize the color
                    size: 50.0, // You can adjust the size
                  ); // Show loading indicator
                }

                if (snapshot.hasError) {
                  return SpinKitRipple(
                    color: Color.fromARGB(
                      255,
                      210,
                      91,
                      212,
                    ), // You can customize the color
                    size: 50.0, // You can adjust the size
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No comments yet.');
                }

                List<Comment> comments = snapshot.data!;

                // Only show the first 2 comments initially
                List<Comment> displayedComments =
                    _isExpanded ? comments : comments.take(2).toList();

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: displayedComments.length,
                      itemBuilder: (context, index) {
                        Comment comment = displayedComments[index];
                        String formattedDate = DateFormat(
                          'MMMM dd, yyyy, h:mm a',
                        ).format(
                          comment.timestamp.toDate(),
                        ); // Format the date as desired
                        return FutureBuilder<DocumentSnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(comment.userId)
                                  .get(), // Fetch user data using comment's userId
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SpinKitRipple(
                                color: Color.fromARGB(
                                  255,
                                  210,
                                  91,
                                  212,
                                ), // You can customize the color
                                size: 50.0, // You can adjust the size
                              ); // Show loading for user data
                            }

                            if (userSnapshot.hasError ||
                                !userSnapshot.hasData) {
                              return Text('Error fetching user data');
                            }

                            String avatarUrl =
                                userSnapshot.data!['avatarUrl'] ??
                                'https://www.example.com/default-avatar.png';

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigate to the UserProfilePage when the commenter's name is clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => UserProfilePage(
                                              userId: comment.userId,
                                            ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        avatarUrl,
                                      ), // Display user's avatar here
                                    ),
                                    title: SelectableText(comment.commentText),
                                    subtitle: Text(
                                      'By: ${comment.userName}  •  ${formattedDate}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 2, indent: 50, endIndent: 50),
                              ],
                            );
                          },
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
                          style: myStyle(
                            fontSize,
                            theme.isDarkTheme
                                ? darkSecTextColor
                                : lightsectextColor,
                          ),
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
