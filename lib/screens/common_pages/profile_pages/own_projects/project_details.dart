/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';


class ProjectDetailsPage extends StatelessWidget {
  final String projectId;

  ProjectDetailsPage({required this.projectId});
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    return Scaffold(
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
     key: _scaffoldKey, // Assign the key to Scaffold
      appBar:
          isMobile
              ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: true,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: true), // Custom Drawer widget,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects') // Access global 'projects' collection
            .doc(projectId) // Use the projectId passed in
            .get(), // Fetch the project document
        builder: (context, snapshot) {
          // Show loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check if the project exists
          if (!snapshot.hasData || snapshot.data!.exists == false) {
            return Center(child: Text('Project not found.'));
          }

          var projectData = snapshot.data!;

          // Safely handle date fields
          DateTime startDate = (projectData['start_date'] ?? Timestamp.now()).toDate();
          DateTime endDate = (projectData['end_date'] ?? Timestamp.now()).toDate();
          String formattedStartDate = startDate.toLocal().toString().split(' ')[0];
          String formattedEndDate = endDate.toLocal().toString().split(' ')[0];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Title: \n${projectData['title']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  'Description: \n${projectData['description']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

                // Status
                Text(
                  'Status: \n${projectData['status']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

                // Start Date
                Text(
                  'Start Date: \n$formattedStartDate',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

                // End Date
                Text(
                  'End Date: \n$formattedEndDate',
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
*/



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;

  ProjectDetailsPage({required this.projectId});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800;

    return Scaffold(
      backgroundColor: theme.isDarkTheme ? Colors.black : lightBackgroundColor,
      key: _scaffoldKey,
      appBar: isMobile
          ? CustomMobileAppBar(
              showSignUpButton: true,
              scaffoldKey: _scaffoldKey,
            )
          : CustomAppBar(showSignUpButton: true),
      drawer: CustomDrawers(showSignUpButton: true),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.exists == false) {
            return Center(
              child: Text(
                'Project not found',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            );
          }

          var projectData = snapshot.data!;
          DateTime startDate = (projectData['start_date'] ?? Timestamp.now()).toDate();
          DateTime endDate = (projectData['end_date'] ?? Timestamp.now()).toDate();
          String formattedStartDate = startDate.toLocal().toString().split(' ')[0];
          String formattedEndDate = endDate.toLocal().toString().split(' ')[0];

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Header with Title and Status
                _buildProjectHeader(projectData, theme),
                
                SizedBox(height: 20),
                
                // Project Images Gallery
                if ((projectData['files'] as List).isNotEmpty)
                  _buildImageGallery(projectData, theme),
                
                SizedBox(height: 30),
                
                // Project Details Section
                _buildProjectDetails(
                  projectData['description'],
                  formattedStartDate,
                  formattedEndDate,
                  theme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectHeader(DocumentSnapshot projectData, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          projectData['title'] ?? 'No Title',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(projectData['status'], theme),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            projectData['status'] ?? 'Unknown',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(DocumentSnapshot projectData, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Images',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (projectData['files'] as List).length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    projectData['files'][index],
                    width: 300,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 300,
                        color: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 300,
                        color: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: theme.isDarkTheme ? Colors.grey[500] : Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDetails(
      String description, String startDate, String endDate, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.isDarkTheme ? darkCardColor : lightCardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              _buildDetailItem(
                icon: Icons.description,
                title: 'Description',
                content: description,
                theme: theme,
              ),
              
              Divider(
                color: theme.isDarkTheme ? Colors.grey[700] : Colors.grey[300],
                height: 30,
              ),
              
              // Timeline
              Text(
                'Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.calendar_today,
                      title: 'Start Date',
                      content: startDate,
                      theme: theme,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.calendar_today,
                      title: 'End Date',
                      content: endDate,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
    required ThemeProvider theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.isDarkTheme ? Colors.grey[400] : Colors.grey[600],
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: theme.isDarkTheme ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
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