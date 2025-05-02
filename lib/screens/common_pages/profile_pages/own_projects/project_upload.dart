/*import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/project_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_button.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';
import 'package:provider/provider.dart'; // Import the provider package


class ProjectUploadForm extends StatefulWidget {
  final String userId; // The user ID to save the project under their profile

  ProjectUploadForm({required this.userId});

  @override
  _ProjectUploadFormState createState() => _ProjectUploadFormState();
}

class _ProjectUploadFormState extends State<ProjectUploadForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _status = ['Completed', 'In-progress'];
  String _selectedStatus = 'Completed';
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _uploadedFiles = []; // Store uploaded file URLs

  // Submit the project using the provider
  void _submitProject() {
    if (_formKey.currentState!.validate()) {
      // Call the provider method to upload the project
      Provider.of<ProjectProvider>(context, listen: false).uploadProject(
        widget.userId,
        _titleController.text,
        _descriptionController.text,
        _selectedStatus,
        _startDate!,
        _endDate!,
        _uploadedFiles,
        context,
      );

      // Clear the form after submission
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedStatus = 'Completed';
        _uploadedFiles = [];
      });
    }
  }

  // Format date to display in the button
  String getFormattedDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.toLocal().toString().split(' ')[0]}';
  }

  @override
  Widget build(BuildContext context) {
     // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(backgroundColor: theme.isDarkTheme?darkBackgroundColor:lightBackgroundColor,
      appBar: CustomAppBar(showSignUpButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom Text Field for Project Title
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Project Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Custom Text Field for Project Description
                CustomTextField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project description';
                    }
                    return null;
                  },
                  labelText: 'Project Description',
                ),
                SizedBox(height: 16),

                // Custom Dropdown for Project Status
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items: _status.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Project Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Row for Start Date Button and Text showing the selected date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      label: 'Pick Start Date',
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        setState(() {
                          if (pickedDate != null) {
                            _startDate = pickedDate;
                          }
                        });
                      },
                    ),
                    Text(
                      getFormattedDate(_startDate),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Row for End Date Button and Text showing the selected date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      label: 'Pick End Date',
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        setState(() {
                          if (pickedDate != null) {
                            _endDate = pickedDate;
                          }
                        });
                      },
                    ),
                    Text(
                      getFormattedDate(_endDate),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Display selected images horizontally
                _uploadedFiles.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _uploadedFiles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                _uploadedFiles[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                SizedBox(height: 16),

                // Submit Button
             
                CustomTextButton2(label: 'Submit Project', onPressed: _submitProject,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/project_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_button.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:myflutterfi/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ProjectUploadForm extends StatefulWidget {
  final String userId;

  const ProjectUploadForm({required this.userId, Key? key}) : super(key: key);

  @override
  _ProjectUploadFormState createState() => _ProjectUploadFormState();
}

class _ProjectUploadFormState extends State<ProjectUploadForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _status = ['Completed', 'In-progress'];
  String _selectedStatus = 'Completed';
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _uploadedFiles = [];
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final storage = FirebaseStorage.instance;
      for (var imageFile in _selectedImages) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
        final ref = storage.ref().child('project_images/${widget.userId}/$fileName');
        
        if (kIsWeb) {
          // For web, convert XFile to Uint8List
          final bytes = await imageFile.readAsBytes();
          await ref.putData(bytes);
        } else {
          // For mobile, use File
          await ref.putFile(File(imageFile.path));
        }
        
        final downloadUrl = await ref.getDownloadURL();
        _uploadedFiles.add(downloadUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload images: $e')),
      );
      rethrow;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _submitProject() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }

      try {
        setState(() {
          _isUploading = true;
        });

        // First upload images if any selected
        if (_selectedImages.isNotEmpty) {
          await _uploadImages();
        }

        // Then submit project with image URLs
        await Provider.of<ProjectProvider>(context, listen: false).uploadProject(
          widget.userId,
          _titleController.text,
          _descriptionController.text,
          _selectedStatus,
          _startDate!,
          _endDate!,
          _uploadedFiles,
          context,
        );

        // Clear the form after successful submission
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedStatus = 'Completed';
          _uploadedFiles = [];
          _selectedImages = [];
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting project: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.toLocal().toString().split(' ')[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
 bool isMobile = width < 800;
    return Scaffold(
      backgroundColor: theme.isDarkTheme ? darkBackgroundColor : lightBackgroundColor,
    key: _scaffoldKey,
      appBar: isMobile
          ? CustomMobileAppBar(
              showSignUpButton: true,
              scaffoldKey: _scaffoldKey,
            )
          : CustomAppBar(showSignUpButton: true),
      drawer: CustomDrawers(showSignUpButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Project Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(  isContent: true,
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project description';
                    }
                    return null;
                  },
                  labelText: 'Project Description',
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items: _status.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Project Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      label: 'Pick Start Date',
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        setState(() {
                          if (pickedDate != null) {
                            _startDate = pickedDate;
                          }
                        });
                      },
                    ),
                    Text(
                      getFormattedDate(_startDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      label: 'Pick End Date',
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        setState(() {
                          if (pickedDate != null) {
                            _endDate = pickedDate;
                          }
                        });
                      },
                    ),
                    Text(
                      getFormattedDate(_endDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Image picker button
                CustomTextButton(
                  label: 'Pick Images',
                  onPressed: _pickImages,
                ),
                SizedBox(height: 8),

                // Selected images preview
                if (_selectedImages.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.isDarkTheme 
                                        ? Colors.white70 
                                        : Colors.black54,
                                  ),
                                ),
                                child: kIsWeb
                                    ? FutureBuilder<Uint8List>(
                                        future: _selectedImages[index].readAsBytes(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Image.memory(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                        },
                                      )
                                    : Image.file(
                                        File(_selectedImages[index].path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),

                // Submit Button
                _isUploading
                    ? CircularProgressIndicator()
                    : CustomTextButton2(
                        label: 'Submit Project',
                        onPressed: _submitProject,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}