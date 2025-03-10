import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_fi/screens/common_pages/profile_pages/own_projects/project_details.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';  // Assuming ProjectDetailsPage is imported

class UserProfilePage extends StatelessWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found.'));
          }

          var userData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Info
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

                  // Projects Header
                  Text(
                    'Projects:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Display Projects using StreamBuilder for real-time updates
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects') // Fetch from global 'projects' collection
                        .where('user_id', isEqualTo: userId) // Filter by 'user_id'
                       // .orderBy('start_date', descending: true) // Sort by start date for most recent project first
                        .snapshots(),
                    builder: (context, projectSnapshot) {
                      if (projectSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!projectSnapshot.hasData || projectSnapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No projects available.' ));
                      
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
                              // Navigate to Project Details Page
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
