import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';
class ProjectDetailsPage extends StatelessWidget {
  final String projectId;

  ProjectDetailsPage({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects') // Access global 'projects' collection
            .doc(projectId) // Use the projectId passed in
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.exists == false) {
            return Center(child: Text('Project not found.'));
          }

          var projectData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${projectData['title']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Description: ${projectData['description']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Status: ${projectData['status']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Start Date: ${projectData['start_date'].toDate()}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'End Date: ${projectData['end_date'].toDate()}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


/* FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
            .collection('projects')
            .doc(projectId)
            .get(),*/