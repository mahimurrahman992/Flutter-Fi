import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/project_provider.dart'; // Import the provider
import 'package:test_flutter_fi/screens/common_pages/profile_pages/own_projects/project_details.dart';
import 'package:test_flutter_fi/screens/common_pages/profile_pages/own_projects/project_upload.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: Text('No user logged in')),
      );
    }

    // Fetch projects using the ProjectProvider
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Info
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var userData = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name: ${userData['fullName'] ?? 'No Name'}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email: ${userData['email'] ?? 'No Email'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Role: ${userData['role'] ?? 'No Role'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),

              // Projects Header
              Text(
                'Projects:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Display Projects using StreamBuilder for real-time updates
              StreamBuilder<QuerySnapshot>(
                stream: Provider.of<ProjectProvider>(context).getProjects(currentUser.uid),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!projectSnapshot.hasData || projectSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No projects available.'));
                  }

                  var projects = projectSnapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(data['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['status'], style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 8),
                            Text(data['description'], maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        // Horizontal List of Images
                        isThreeLine: true,
                        trailing: SizedBox(
                          height: 60,
                          width: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (data['files'] as List).length,
                            itemBuilder: (context, imgIndex) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  data['files'][imgIndex],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsPage(projectId: doc.id),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList();

                  return ListView(
                    shrinkWrap: true,
                    children: projects,
                  );
                },
              ),

              SizedBox(height: 20),

              // Add Project Button at the Bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectUploadForm(userId: currentUser.uid),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Add Project',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
