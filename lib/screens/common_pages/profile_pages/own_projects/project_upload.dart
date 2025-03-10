import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:test_flutter_fi/providers/project_provider.dart'; // Import the ProjectProvider

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Project Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Project Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project description';
                  }
                  return null;
                },
              ),
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
                decoration: InputDecoration(labelText: 'Project Status'),
              ),
              ElevatedButton(
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
                child: Text('Pick Start Date'),
              ),
              ElevatedButton(
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
                child: Text('Pick End Date'),
              ),
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
              ElevatedButton(
                onPressed: _submitProject,
                child: Text('Submit Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
