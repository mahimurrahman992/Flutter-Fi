import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter_fi/widgets/custom_blog_card.dart';

class UserPanel extends StatefulWidget {
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> with TickerProviderStateMixin {
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Fix the Scaffold error here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Saved Blogs'),
            Tab(text: 'Liked Blogs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Saved Blogs Tab
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(userUid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var userDoc = snapshot.data!;
              var savedBlogs = userDoc['savedBlogs'] ?? [];

              if (savedBlogs.isEmpty) {
                return Center(child: Text('No saved blogs.'));
              }

              return StreamBuilder(
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
                      var blogData = blog.data();

                      return CustomBlogCard(
                        blogId: blog.id,
                        title: blogData['title'] ?? 'No Title',
                        content: blogData['content'] ?? 'No Content',
                        category: blogData['category'] ?? 'No Category',
                        adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                        fullName: blogData['fullName']??'No Admin Name',
                        createdAt: blogData['createdAt']?? 'No createdAt',
                      );
                    },
                  );
                },
              );
            },
          ),

          // Liked Blogs Tab
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var blogsData = snapshot.data!.docs;
              var likedBlogs = blogsData.where((blog) {
                var blogData = blog.data();
                List<dynamic> likes = blogData['likes'] ?? [];
                return likes.contains(FirebaseAuth.instance.currentUser!.email);
              }).toList();

              if (likedBlogs.isEmpty) {
                return Center(child: Text('No liked blogs.'));
              }

              return ListView.builder(
                itemCount: likedBlogs.length,
                itemBuilder: (context, index) {
                  var blog = likedBlogs[index];
                  var blogData = blog.data();

                  return CustomBlogCard(
                    blogId: blog.id,
                    title: blogData['title'] ?? 'No Title',
                    content: blogData['content'] ?? 'No Content',
                    category: blogData['category'] ?? 'No Category',
                    adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                    fullName: blogData['fullName']??'No Admin Name',
                    createdAt: blogData['createdAt']??'No createdAt',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
