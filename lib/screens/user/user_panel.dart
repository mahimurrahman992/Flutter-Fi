import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_blog_card.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';


class UserPanel extends StatefulWidget {
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  int _currentIndex = 0; // To track the currently selected tab
  late PageController _pageController; // To control the PageView
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentIndex); // Initialize PageController
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
 double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    return Scaffold(
      backgroundColor:
          theme.isDarkTheme ? darkBackgroundColor : lightBackgroundColor,
    key: _scaffoldKey, // Assign the key to Scaffold
      appBar:
          isMobile
              ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: true,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: true), // Custom Drawer widget,
      body: PageView(
        controller: _pageController, // Set the PageController
        onPageChanged: (index) {
          setState(() {
            _currentIndex =
                index; // Update the currentIndex when the page changes
          });
        },
        children: [
          // Saved Blogs Tab
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var userDoc = snapshot.data!;
              var savedBlogs = userDoc['savedBlogs'] ?? [];

              if (savedBlogs.isEmpty) {
                return Center(child: Text('No saved blogs.'));
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('blogs')
                    .where(FieldPath.documentId, whereIn: savedBlogs)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var savedBlogsData = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: savedBlogsData.length,
                    itemBuilder: (context, index) {
                      var blog = savedBlogsData[index];
                      var blogData = blog.data() as Map<String, dynamic>;

                      return CustomBlogCard(
                        blogId: blog.id,
                        title: blogData['title'] ?? 'No Title',
                        content: blogData['content'] ?? 'No Content',
                        category: blogData['category'] ?? 'No Category',
                        adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                        fullName: blogData['fullName'] ?? 'No Admin Name',
                        createdAt: blogData['createdAt'] ?? 'No createdAt',
                      );
                    },
                  );
                },
              );
            },
          ),

          // Liked Blogs Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var blogsData = snapshot.data!.docs;

              // Filter blogs where the current user's email is in the 'likes' field
              var likedBlogs = blogsData.where((blog) {
                var blogData = blog.data() as Map<String, dynamic>;
                List<dynamic> likes = blogData['likes'] ?? [];

                // Check if the current user's email is in the 'likes' array
                return likes.any((like) =>
                    like['email'] == FirebaseAuth.instance.currentUser!.email);
              }).toList();

              if (likedBlogs.isEmpty) {
                return Center(child: Text('No liked blogs.'));
              }

              return ListView.builder(
                itemCount: likedBlogs.length,
                itemBuilder: (context, index) {
                  var blog = likedBlogs[index];
                  var blogData = blog.data() as Map<String, dynamic>;

                  return CustomBlogCard(
                    blogId: blog.id,
                    title: blogData['title'] ?? 'No Title',
                    content: blogData['content'] ?? 'No Content',
                    category: blogData['category'] ?? 'No Category',
                    adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                    fullName: blogData['fullName'] ?? 'No Admin Name',
                    createdAt: blogData['createdAt'] ?? 'No createdAt',
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar:Theme(
        data: ThemeData(
          // Ensure consistent colors for the BottomNavigationBar in both themes
          primaryColor: theme.isDarkTheme ? Colors.deepPurple : Colors.deepPurple,
          canvasColor: theme.isDarkTheme
              ? Color.fromARGB(201, 252, 163, 193)
              : Color.fromARGB(201, 252, 163, 193), // Background color for the BottomNavigationBar
          unselectedWidgetColor:  Colors.white , // Unselected item color
        ),
        child: BottomNavigationBar(selectedItemColor: Colors.deepPurple,
            currentIndex: _currentIndex, // Set the currently selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease); // Animate the page change
          });
        },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.save_alt),
              label: 'Saved Blog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              label: 'Liked Blogs',
            ),
          
          ],
        ),
      ), 
    );
  }
}