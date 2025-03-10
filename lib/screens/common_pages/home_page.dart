import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';
import 'package:test_flutter_fi/widgets/custom_blog_card.dart';
import 'package:test_flutter_fi/widgets/custom_drop_down.dart';
import 'package:test_flutter_fi/widgets/custom_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _blogs = [];
  List<QueryDocumentSnapshot> _filteredBlogs = [];
  List<String> _categories = []; // List of categories for filtering
  String? _selectedCategory; // Selected category for filtering

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
    _fetchCategories();
    _searchController.addListener(_filterBlogs);
  }

  // Fetch all blogs from Firestore
  void _fetchBlogs() {
    FirebaseFirestore.instance.collection('blogs').get().then((snapshot) {
      setState(() {
        _blogs = snapshot.docs;
        _filteredBlogs = _blogs; // Initially show all blogs
        _sortBlogs(); // Sort blogs by likes or comments
      });
    });
  }

  // Fetch categories from Firestore for filtering
  void _fetchCategories() {
    FirebaseFirestore.instance.collection('categories').get().then((snapshot) {
      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
        _categories.insert(0, 'All'); // Add 'All' as the default category option
      });
    });
  }

  // Function to filter blogs based on the search query
  void _filterBlogs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBlogs = _blogs
          .where((blog) =>
              blog['title'].toLowerCase().contains(query) || // Search by title (name)
              blog['content'].toLowerCase().contains(query) || // Search by content
              blog['category'].toLowerCase().contains(query) || // Search by category
              blog['adminEmail'].toLowerCase().contains(query)) // Search by admin (email)
          .toList();
    });
  }

  // Function to sort blogs by likes or comments
  void _sortBlogs() {
    // Sort by likes or comments (change this logic as needed)
    _filteredBlogs.sort((a, b) {
      int aLikes = (a['likes'] as List<dynamic>).length; // Assuming likes is a list
      int bLikes = (b['likes'] as List<dynamic>).length;
      return bLikes.compareTo(aLikes); // Sort descending by likes
    });
  }

  // Handle category change
  void _onCategoryChanged(String? value) {
    setState(() {
      _selectedCategory = value;
      _filterBlogs(); // Re-filter blogs based on the selected category
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
 
    return Scaffold(
      appBar: CustomAppBar(
        showSignUpButton: true,
      ),
      backgroundColor: theme.isDarkTheme?Colors.black:lightBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap Column with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 350),
                child: CustomTextField(
                  controller: _searchController,
                  labelText: 'Search Blogs',
                  hintText: 'Search by name, content, category, or admin',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a search query';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20), // Add some space below the search bar

            // Custom Dropdown
            CustomDropdown(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
              SizedBox(height: 20), // Space between the dropdown and blog list

              // Display the most liked blog as the first and large
              _filteredBlogs.isEmpty
                  ? Center(child: Text('No blogs found.'))
                  : Column(
                      children: [
                        // Display the most liked blog (large)
                        if (_filteredBlogs.isNotEmpty)
                          CustomBlogCard(
                            blogId: _filteredBlogs[0].id,
                            title: _filteredBlogs[0]['title'] ?? 'No Title',
                            content: _filteredBlogs[0]['content'] ?? 'No Content',
                            category: _filteredBlogs[0]['category'] ?? 'No Category',
                            adminEmail: _filteredBlogs[0]['adminEmail'] ?? 'No Admin Email',
                            fullName: _filteredBlogs[0]['fullName']?? 'No Admin Name',
                            createdAt: _filteredBlogs[0]['createdAt']??'No createdAt',
                            isLarge: true, // Make this card large
                          ),
                        SizedBox(height: 20), // Space between large and normal blogs

                        // Display remaining blogs normally
                        ListView.builder(
                          shrinkWrap: true, // Make ListView scrollable inside Column
                          itemCount: _filteredBlogs.length > 1
                              ? _filteredBlogs.length - 1
                              : 0,
                          itemBuilder: (context, index) {
                            var blog = _filteredBlogs[index + 1]; // Skip the first large blog
                            var blogData = blog.data() as Map<String, dynamic>;

                            return CustomBlogCard(
                              blogId: blog.id,
                              title: blogData['title'] ?? 'No Title',
                              content: blogData['content'] ?? 'No Content',
                              category: blogData['category'] ?? 'No Category',
                              adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                              fullName: blogData['fullName']?? 'No Admin Name',
                              isLarge: false, // Normal size
                              createdAt: blogData['createdAt']??'No createdAt',
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
