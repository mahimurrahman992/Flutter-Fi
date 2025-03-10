
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_fi/services/firebase_services.dart';
import 'package:test_flutter_fi/widgets/custom_button.dart';
import 'package:test_flutter_fi/widgets/custom_textfield.dart';

class CreateBlogPage extends StatefulWidget {
  @override
  _CreateBlogPageState createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  //String? _selectedCategory;
  //List<String> _categories = [];
  bool _isLoading = false;
 final FirebaseService _firebaseService = FirebaseService(); 
 
String? _selectedCategory;
  List<String> _categories = [];

 @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firebaseService.getCategories().listen((categories) {
      setState(() {
        _categories = categories;
        // Ensure the selected category is valid
        if (_selectedCategory != null && !_categories.contains(_selectedCategory)) {
          _selectedCategory = null;
        }
      });
      print('Fetched categories: $_categories'); // Debugging statement
    }, onError: (error) {
      print('Error fetching categories: $error'); // Debugging statement
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Enter the blog title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: _contentController,
                labelText: 'Content',
                hintText: 'Enter the blog content',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
          DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList()
                  ..add(
                    DropdownMenuItem(
                      value: 'create_new',
                      child: Text('Create New Category'),
                    ),
                  ),
                onChanged: (value) {
                  if (value == 'create_new') {
                    _showCreateCategoryDialog();
                  } else {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                   validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color.fromARGB(255, 155, 85, 174), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Input field for new category
             /* TextFormField(
                controller: _newCategoryController,
                decoration: InputDecoration(labelText: 'Create New Category'),
                onFieldSubmitted: (_) {
                  _createNewCategory();
                },
              ),*/
              SizedBox(height: 20),
              CustomButton(
                label: 'Submit',
                onPressed:   _createBlog,
                color: Colors.purple,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _createBlog() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if the user is authenticated and email is not null
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not authenticated')));
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      String adminEmail = user.email!;
      
      
      // Fetch the fullName from the 'users' collection using the 'email' field
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: adminEmail) // Query based on 'email' field
          .get();

      // Check if a user document exists
      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found in users collection')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String fullName = userSnapshot.docs[0]['fullName'];

      // Check if the selected category is null or empty
      if (_selectedCategory == null || _selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a category')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Call the Firebase service to create the blog
      await _firebaseService.createBlog(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory!,  // Now we are sure it’s not null
        adminEmail: adminEmail,
        fullName: fullName, 

      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blog Created Successfully')));

      // Clear the form after successful creation
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedCategory = null;
      });

      // Optionally, navigate to another screen (e.g., the blog list or admin dashboard)
      // Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create blog')));
      print(e);  // Print error for debugging
    }
  }
}
 void _showCreateCategoryDialog() {
    final _newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: InputDecoration(hintText: 'Enter new category'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
              TextButton(
              onPressed: () async {
                final newCategory = _newCategoryController.text.trim();
                if (newCategory.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category name cannot be empty')),
                  );
                  return;
                }
                  if (_categories.contains(newCategory)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category already exists')),
                  );
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                await _firebaseService.addCategory(newCategory);
                setState(() {
                  _categories.add(newCategory);
                  _selectedCategory = newCategory;
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              },
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Create'),
            ),
          ]);
      },
    );
  }
}
