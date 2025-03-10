import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';
import 'package:test_flutter_fi/widgets/custom_blog_card.dart';

import 'package:test_flutter_fi/widgets/custom_textfield.dart';  // Ensure CustomTextField is imported

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _categories = [];
  List<String> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(_filterCategories);
  }

  // Function to fetch categories from Firestore
  void _fetchCategories() {
    FirebaseFirestore.instance.collection('categories').get().then((snapshot) {
      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
        _filteredCategories = _categories; // Initially, show all categories
      });
    });
  }

  // Function to filter categories based on the first letter of the search query
  void _filterCategories() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      // Filter categories that start with the query string
      _filteredCategories = _categories
          .where((category) => category.toLowerCase().startsWith(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            CustomTextField(
              controller: _searchController,
              labelText: 'Search Categories ',
              hintText: 'Type a letter to filter...',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a letter';
                }
                return null;
              },
            ),
            SizedBox(height: 20), // Add some space below the search bar

            // Display Categories
            _filteredCategories.isEmpty
                ? Center(child: Text('No categories found.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        String categoryName = _filteredCategories[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              categoryName,
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              // Navigate to BlogsByCategory page when a category is selected
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlogsByCategory(category: categoryName),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class BlogsByCategory extends StatelessWidget {
  final String category;

  BlogsByCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blogs')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No blogs available for this category.'));
          }

          var blogs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              var blog = blogs[index];
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
    );
  }
}
