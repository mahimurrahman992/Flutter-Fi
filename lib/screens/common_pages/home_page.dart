import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_blog_card.dart';
import 'package:myflutterfi/widgets/custom_drop_down.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _blogs = [];
  List<QueryDocumentSnapshot> _filteredBlogs = [];
  List<String> _categories = [];
  String? _selectedCategory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
    _fetchCategories();
    _searchController.addListener(_filterBlogs);
  }

  void _fetchBlogs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('createdAt', descending: true) // Sort by newest first
          .get();
      setState(() {
        _blogs = snapshot.docs;
        _filteredBlogs = _blogs;
        _sortBlogs();
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  void _fetchCategories() async {
    try {
      QuerySnapshot snapshot = 
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
        _categories.insert(0, 'All');
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _filterBlogs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBlogs = _blogs.where((blog) {
        final blogData = blog.data() as Map<String, dynamic>;
        return blogData['title'].toLowerCase().contains(query) ||
               blogData['content'].toLowerCase().contains(query) ||
               blogData['category'].toLowerCase().contains(query) ||
               blogData['adminEmail'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _sortBlogs() {
    _filteredBlogs.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;
      int aLikes = (aData['likes'] as List<dynamic>?)?.length ?? 0;
      int bLikes = (bData['likes'] as List<dynamic>?)?.length ?? 0;
      return bLikes.compareTo(aLikes);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
 double screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          key: _scaffoldKey,
          appBar: isMobile
              ? CustomMobileAppBar(showSignUpButton: true, scaffoldKey: _scaffoldKey)
              : CustomAppBar(showSignUpButton: true),
          drawer: CustomDrawers(showSignUpButton: true),
          backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: CustomTextField(width:screenWidth*0.5 ,
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
                  SizedBox(height: 20),

                  CustomDropdown(
                    isHome: false,
                    hint: 'Select Category',
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _filteredBlogs = value == 'All' 
                            ? _blogs 
                            : _blogs.where((blog) => 
                                (blog.data() as Map<String, dynamic>)['category'] == value
                              ).toList();
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  _filteredBlogs.isEmpty
                      ? Center(child: Text('No blogs found.'))
                      : Column(
                          children: [
                            // Featured blog (first in list)
                            if (_filteredBlogs.isNotEmpty)
                              CustomBlogCard(
                                blogId: _filteredBlogs[0].id,
                                title: _filteredBlogs[0]['title'] ?? 'No Title',
                                content: _filteredBlogs[0]['content'] ?? 'No Content',
                                category: _filteredBlogs[0]['category'] ?? 'No Category',
                                adminEmail: _filteredBlogs[0]['adminEmail'] ?? 'No Admin Email',
                                fullName: _filteredBlogs[0]['fullName'] ?? 'No Admin Name',
                                createdAt: _filteredBlogs[0]['createdAt'] ?? Timestamp.now(),
                                imageUrls: _filteredBlogs[0]['imageUrls'] != null 
                                    ? List<String>.from(_filteredBlogs[0]['imageUrls'])
                                    : null,
                                isLarge: true,
                              ),
                            SizedBox(height: 20),

                            // Remaining blogs
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _filteredBlogs.length > 1 ? _filteredBlogs.length - 1 : 0,
                              itemBuilder: (context, index) {
                                var blog = _filteredBlogs[index + 1];
                                var blogData = blog.data() as Map<String, dynamic>;

                                return Column(
                                  children: [
                                    CustomBlogCard(
                                      blogId: blog.id,
                                      title: blogData['title'] ?? 'No Title',
                                      content: blogData['content'] ?? 'No Content',
                                      category: blogData['category'] ?? 'No Category',
                                      adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                                      fullName: blogData['fullName'] ?? 'No Admin Name',
                                      createdAt: blogData['createdAt'] ?? Timestamp.now(),
                                      imageUrls: blogData['imageUrls'] != null 
                                          ? List<String>.from(blogData['imageUrls'])
                                          : null,
                                      isLarge: false,
                                    ),
                                    SizedBox(height: 16),
                                  ],
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
      },
    );
  }
}












/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_blog_card.dart';
import 'package:myflutterfi/widgets/custom_drop_down.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

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
  void _fetchBlogs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('blogs').get();
      setState(() {
        _blogs = snapshot.docs;
        _filteredBlogs = _blogs; // Initially show all blogs
        _sortBlogs(); // Sort blogs by likes or comments
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  // Fetch categories from Firestore for filtering
  void _fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
        _categories.insert(
          0,
          'All',
        ); // Add 'All' as the default category option
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Function to filter blogs based on the search query
  void _filterBlogs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBlogs =
          _blogs.where((blog) {
            final blogData = blog.data() as Map<String, dynamic>;
            return blogData['title'].toLowerCase().contains(
                  query,
                ) || // Search by title
                blogData['content'].toLowerCase().contains(
                  query,
                ) || // Search by content
                blogData['category'].toLowerCase().contains(
                  query,
                ) || // Search by category
                blogData['adminEmail'].toLowerCase().contains(
                  query,
                ); // Search by admin email
          }).toList();
    });
  }

  // Function to sort blogs by likes or comments
  void _sortBlogs() {
    _filteredBlogs.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;
      int aLikes =
          (aData['likes'] as List<dynamic>).length; // Assuming likes is a list
      int bLikes = (bData['likes'] as List<dynamic>).length;
      return bLikes.compareTo(aLikes); // Sort descending by likes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800; // Mobile screen check

        return Scaffold(
          appBar: CustomAppBar(showSignUpButton: true),

          backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                  SizedBox(height: 20),

                  // Custom Dropdown for Category Filtering
                  CustomDropdown(
                    hint: 'Select Category',
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        if (value == 'All') {
                          _filteredBlogs = _blogs; // Show all blogs
                        } else {
                          _filteredBlogs =
                              _blogs
                                  .where(
                                    (blog) =>
                                        (blog.data()
                                            as Map<String, dynamic>)['category'] ==
                                        value,
                                  )
                                  .toList();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Display Blogs
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
                                category:
                                    _filteredBlogs[0]['category'] ?? 'No Category',
                                adminEmail:
                                    _filteredBlogs[0]['adminEmail'] ?? 'No Admin Email',
                                fullName: _filteredBlogs[0]['fullName'] ?? 'No Admin Name',
                                createdAt: _filteredBlogs[0]['createdAt'] ?? Timestamp.now(),
                                isLarge: true, // Make this card large
                              ),
                            SizedBox(height: 20),

                            // Display remaining blogs
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling
                              itemCount: _filteredBlogs.length > 1
                                  ? _filteredBlogs.length - 1
                                  : 0,
                              itemBuilder: (context, index) {
                                var blog =
                                    _filteredBlogs[index + 1]; // Skip the first large blog
                                var blogData = blog.data() as Map<String, dynamic>;

                                return CustomBlogCard(
                                  blogId: blog.id,
                                  title: blogData['title'] ?? 'No Title',
                                  content: blogData['content'] ?? 'No Content',
                                  category: blogData['category'] ?? 'No Category',
                                  adminEmail: blogData['adminEmail'] ?? 'No Admin Email',
                                  fullName: blogData['fullName'] ?? 'No Admin Name',
                                  createdAt: blogData['createdAt'] ?? Timestamp.now(),
                                  isLarge: false, // Normal size
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
      },
    );
  }
}
*/