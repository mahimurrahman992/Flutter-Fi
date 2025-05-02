// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/project_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/features_screeen/projects/global_project_details.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart'; // Import provider package


class ProjectsPage extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold( key: _scaffoldKey, // Assign the key to Scaffold
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      appBar:           isMobile
              ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: true,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: true), // Custom Drawer widget
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProjectProvider>(
          builder: (context, projectProvider, child) {
            // Fetch all projects using the ProjectProvider
            return StreamBuilder<QuerySnapshot>(
              stream:
                  projectProvider.fetchProjects(), // Fetch projects globally
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No projects available.'));
                }

                // Extract project data and display it in a card view
                var projects = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  // Extract project data
                  String title = data['title'] ?? 'No Title';
                  String description =
                      data['description'] ?? 'No Description Available';
                  String status = data['status'] ?? 'No Status';
                  DateTime startDate =
                      (data['start_date'] ?? Timestamp.now()).toDate();
                  DateTime endDate =
                      (data['end_date'] ?? Timestamp.now()).toDate();
                  List<dynamic> files = data['files'] ?? [];
                  String userId = data['user_id'] ??
                      'Unknown User'; // User who uploaded the project

                  // Format the start and end dates
                  String formattedStartDate =
                      startDate.toLocal().toString().split(' ')[0];
                  String formattedEndDate =
                      endDate.toLocal().toString().split(' ')[0];

                  return Card(
                     elevation: 4,
                                  color: theme.isDarkTheme
                                      ? darkCardColor
                                      : lightCardColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(status, style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                          Text(description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: SizedBox(
                        height: 60,
                        width: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (files).length,
                          itemBuilder: (context, imgIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                files[
                                    imgIndex], // Assuming the files are image URLs
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      onTap: () {
                        // Navigate to project details when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GlobalProjectDetailsPage(projectId: doc.id),
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
            );
          },
        ),
      ),
    );
  }
}
