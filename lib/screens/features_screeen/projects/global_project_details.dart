import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';

class GlobalProjectDetailsPage extends StatelessWidget {
  final String projectId;

  GlobalProjectDetailsPage({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch the project details from the global 'projects' collection
        future: FirebaseFirestore.instance
            .collection('projects') // Access global 'projects' collection
            .doc(projectId) // Use the projectId passed in
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Project not found.'));
          }

          var projectData = snapshot.data!;

          // Safe access to project data with fallback values
          String title = projectData['title'] ?? 'No Title';
          String description = projectData['description'] ?? 'No Description Available';
          String status = projectData['status'] ?? 'No Status';
          DateTime startDate = (projectData['start_date'] ?? Timestamp.now()).toDate();
          DateTime endDate = (projectData['end_date'] ?? Timestamp.now()).toDate();
          List<dynamic> files = projectData['files'] ?? [];
          String userId = projectData['user_id'] ?? 'Unknown User'; // User who uploaded the project

          // Format the start and end dates
          String formattedStartDate = startDate.toLocal().toString().split(' ')[0];
          String formattedEndDate = endDate.toLocal().toString().split(' ')[0];

          // Fetch the uploader's name using user_id
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId) // Use the user_id to get the user details
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text('Uploader not found.'));
              }

              var userData = userSnapshot.data!;
              String uploaderName = userData['fullName'] ?? 'Unknown Uploader';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Title
                      Text(
                        'Title: $title',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Project Description
                      Text(
                        'Description: $description',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      // Project Status
                      Text(
                        'Status: $status',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      // Project Start Date
                      Text(
                        'Start Date: $formattedStartDate',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      // Project End Date
                      Text(
                        'End Date: $formattedEndDate',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),

                      // Display Uploader's Name
                      Text(
                        'Uploaded by: $uploaderName',
                        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                      ),
                      SizedBox(height: 20),

                      // Project Files (Images/Documents)
                      files.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Files:',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: files.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.network(
                                          files[index],  // Assuming the files are image URLs
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),

                      SizedBox(height: 20),

                      // Optionally, Add any other actions or buttons (e.g., Edit, Contact)
                      ElevatedButton(
                        onPressed: () {
                          // Action (e.g., Edit Project, Contact Person)
                        },
                        child: Text('Contact / Edit Project'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
