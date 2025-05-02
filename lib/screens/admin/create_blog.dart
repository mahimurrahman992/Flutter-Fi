

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/common_pages/home_page.dart';
import 'package:myflutterfi/services/firebase_services.dart';
import 'package:myflutterfi/widgets/custom_button.dart';
import 'package:myflutterfi/widgets/custom_drop_down.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class CreateBlogPage extends StatefulWidget {
  @override
  _CreateBlogPageState createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  

  bool _isLoading = false;
  String? _selectedCategory;
  List<String> _categories = [];
  List<html.File>? _selectedImages; // Make it nullable
  List<String>? _imageUrls; // Make it nullable

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _selectedImages = []; // Initialize as empty list
    _imageUrls = []; // Initialize as empty list
  }

  void _fetchCategories() {
    _firebaseService.getCategories().listen((categories) {
      setState(() {
        _categories = categories;
        if (_selectedCategory != null && !_categories.contains(_selectedCategory)) {
          _selectedCategory = null;
        }
      });
    }, onError: (error) {
      print('Error fetching categories: $error');
    });
  }

  Future<void> _pickImages() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.multiple = true;
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          setState(() {
            _selectedImages = List.from(files); // Create new list from selected files
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages == null || _selectedImages!.isEmpty) {
      return; // No images to upload
    }

    _imageUrls = []; // Reset image URLs
    
    setState(() {
      _isLoading = true;
    });

    try {
      for (var image in _selectedImages!) {
        final fileName = 'blog_images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        final UploadTask uploadTask = storageRef.putBlob(image);

        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        
        _imageUrls!.add(downloadUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload images: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createBlog() async {
    if (_formKey.currentState!.validate()) {
      // Remove the mandatory image requirement
      // if (_selectedImages == null || _selectedImages!.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Please select at least one image')),
      //   );
      //   return;
      // }

      setState(() {
        _isLoading = true;
      });

      try {
        // Only upload images if they exist
        if (_selectedImages != null && _selectedImages!.isNotEmpty) {
          await _uploadImages();
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not authenticated')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        String adminEmail = user.email!;

        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: adminEmail)
            .get();

        if (userSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found in users collection')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        String fullName = userSnapshot.docs[0]['fullName'];

        if (_selectedCategory == null || _selectedCategory!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a category')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await _firebaseService.createBlog(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _selectedCategory!,
          adminEmail: adminEmail,
          fullName: fullName,
          imageUrls: _imageUrls ?? [], // Use empty list if null
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog Created Successfully')),
        );

        _titleController.clear();
        _contentController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedImages = [];
          _imageUrls = [];
          _isLoading = false;
        });
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create blog: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages?.removeAt(index); // Safe removal
    });
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Blog'),
        backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image Picker Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Images (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedImages != null && _selectedImages!.isNotEmpty)
                      Container(
                        height: 200,
                        child: PageView.builder(
                          itemCount: _selectedImages!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        html.Url.createObjectUrl(_selectedImages![index]),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 16,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No images selected',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: Text(_selectedImages != null && _selectedImages!.isNotEmpty 
                          ? 'Add More Images' 
                          : 'Select Images',style: myStyle(18, Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color.fromARGB(255, 228, 130, 162),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                
                // Blog Form Fields
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
                  isContent: true,
                ),
                SizedBox(height: 15),
                CustomDropdown(
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  onChanged: (value) {
                    if (value == 'create_new') {
                      _showCreateCategoryDialog();
                    } else {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  hint: 'Select Category',
                ),
                SizedBox(height: 25),
                
                // Submit Button
                _isLoading
                    ? CircularProgressIndicator()
                    : CustomTextButton2(
                        label: 'Submit',
                        onPressed: _createBlog,
                        fontSize: 25,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}