import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProjectProvider with ChangeNotifier {
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // Method to fetch projects
  Stream<QuerySnapshot> getProjects(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .orderBy('start_date', descending: true)
        .snapshots();
  }
  // Method to upload the project
  Future<void> uploadProject(
      String userId,
      String title,
      String description,
      String status,
      DateTime startDate,
      DateTime endDate,
      List<String> uploadedFiles,
      BuildContext context) async {
    _isUploading = true;
    notifyListeners();

    try {
      // Upload the project to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .add({
        'title': title,
        'description': description,
        'status': status,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'files': uploadedFiles,
      });
  // Upload the project to Firestore in the global 'projects' collection
      await FirebaseFirestore.instance.collection('projects').add({
        'title': title,
        'description': description,
        'status': status,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'user_id': userId,
        'files': uploadedFiles,
      });
      // Reset upload state after successful submission
      _isUploading = false;
      notifyListeners();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project uploaded successfully!')),
      );
    } catch (e) {
      // Handle errors
      _isUploading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading project')),
      );
    }
  }
  // Method to fetch project details based on the projectId
  Future<DocumentSnapshot> fetchProjectDetails(String projectId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch the project document
      DocumentSnapshot projectSnapshot = await FirebaseFirestore.instance
          .collection('projects') // Access global projects collection (public)
          .doc(projectId) // Use projectId to fetch the project
          .get();

      _isLoading = false;
      notifyListeners();
      
      return projectSnapshot;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw 'Error fetching project details: $e';
    }
  }

  // Method to fetch all projects from the 'projects' collection
  Stream<QuerySnapshot> fetchProjects() {
    try {
      // Fetch projects in a non-blocking manner, to avoid calling during widget rebuilds
      _isLoading = true;
      notifyListeners();

      // Fetch all projects from the global 'projects' collection
      return FirebaseFirestore.instance
          .collection('projects') // Access global 'projects' collection
          .orderBy('start_date', descending: true) // Order projects by start date
          .snapshots();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw 'Error fetching projects: $e';
    }
  }

  // Optionally, if there's an operation where you need to use setState (outside of the build phase)
  void updateLoadingStatus(bool status) {
    _isLoading = status;
    // Delay the notifyListeners to avoid the build phase error
    Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
