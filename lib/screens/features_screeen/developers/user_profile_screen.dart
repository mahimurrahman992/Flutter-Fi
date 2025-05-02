/*import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/own_projects/project_details.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';


class UserProfilePage extends StatelessWidget {
  final String userId;

  UserProfilePage({required this.userId});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
       double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    return Scaffold(key: _scaffoldKey, // Assign the key to Scaffold
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      appBar:   isMobile
              ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: true,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: true), // Custom Drawer widget
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
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
                        .collection(
                            'projects') // Fetch from global 'projects' collection
                        .where('user_id',
                            isEqualTo: userId) // Filter by 'user_id'
                        // .orderBy('start_date', descending: true) // Sort by start date for most recent project first
                        .snapshots(),
                    builder: (context, projectSnapshot) {
                      if (projectSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!projectSnapshot.hasData ||
                          projectSnapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No projects available.'));
                      }

                      var projects = projectSnapshot.data!.docs.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;

                        return Card(
                          elevation: 4,
                          color: theme.isDarkTheme
                              ? darkCardColor
                              : lightCardColor,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(data['title'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['status'],
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 8),
                                Text(data['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
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
                                  builder: (context) =>
                                      ProjectDetailsPage(projectId: doc.id),
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
*/




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/own_projects/project_details.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;

  UserProfilePage({required this.userId});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      appBar: isMobile
          ? CustomMobileAppBar(
              showSignUpButton: true,
              scaffoldKey: _scaffoldKey,
            )
          : CustomAppBar(showSignUpButton: true),
      drawer: CustomDrawers(showSignUpButton: true),
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

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                _buildProfileHeader(context, userData, theme),
                
                // Projects Section
                _buildProjectsSection(context, userId, theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, DocumentSnapshot userData, ThemeProvider theme) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.isDarkTheme ? darkCardColor : lightCardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
            backgroundImage: NetworkImage(userData['avatarUrl']),
          ),
          SizedBox(height: 20),
          Text(
            userData['fullName'] ?? 'No Name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Chip(
            backgroundColor: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
            label: Text(
              userData['role'] ?? 'No Role',
              style: TextStyle(
                color: theme.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: theme.isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                userData['email'] ?? 'No Email',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, String userId, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 15),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .where('user_id', isEqualTo: userId)
                .snapshots(),
            builder: (context, projectSnapshot) {
              if (projectSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!projectSnapshot.hasData || projectSnapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No projects yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 800 ? 2 : 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: projectSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = projectSnapshot.data!.docs[index];
                  var data = doc.data() as Map<String, dynamic>;

                  return _buildProjectCard(context, doc.id, data, theme);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, String projectId, Map<String, dynamic> data, ThemeProvider theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(projectId: projectId),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: theme.isDarkTheme ? darkCardColor : lightCardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image (first image if available)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  color: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                ),
                child: (data['files'] as List).isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          data['files'][0],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.photo_library,
                          size: 50,
                          color: theme.isDarkTheme ? Colors.grey[500] : Colors.grey[400],
                        ),
                      ),
              ),
            ),
            // Project Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title'] ?? 'No Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(data['status'], theme),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data['status'] ?? 'Unknown',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if ((data['files'] as List).length > 1)
                          Row(
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: 16,
                                color: theme.isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${(data['files'] as List).length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeProvider theme) {
    switch (status.toLowerCase()) {
      case 'Completed':
        return Colors.green;
      case 'in-progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return theme.isDarkTheme ? Colors.grey[700]! : Colors.grey;
    }
  }
}