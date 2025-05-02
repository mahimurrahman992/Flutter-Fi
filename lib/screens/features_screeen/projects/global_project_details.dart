/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';


class GlobalProjectDetailsPage extends StatelessWidget {
  final String projectId;

  GlobalProjectDetailsPage({required this.projectId});
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
          String description =
              projectData['description'] ?? 'No Description Available';
          String status = projectData['status'] ?? 'No Status';
          DateTime startDate =
              (projectData['start_date'] ?? Timestamp.now()).toDate();
          DateTime endDate =
              (projectData['end_date'] ?? Timestamp.now()).toDate();
          List<dynamic> files = projectData['files'] ?? [];
          String userId = projectData['user_id'] ??
              'Unknown User'; // User who uploaded the project

          // Format the start and end dates
          String formattedStartDate =
              startDate.toLocal().toString().split(' ')[0];
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
                      SelectableText(
                        'Title: \n$title',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Project Description
                      SelectableText(
                        'Description:\n $description',
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
                      SelectableText(
                        'Start Date:\n $formattedStartDate',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      // Project End Date
                      SelectableText(
                        'End Date:\n $formattedEndDate',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),

                      // Display Uploader's Name
                      SelectableText(
                        'Uploaded by: $uploaderName',
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                      SizedBox(height: 20),

                      // Project Files (Images/Documents)
                      files.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Files:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                          files[
                                              index], // Assuming the files are image URLs
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
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';

class GlobalProjectDetailsPage extends StatelessWidget {
  final String projectId;

  GlobalProjectDetailsPage({required this.projectId});
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

          if (!snapshot.hasData || !snapshot.data!.exists) {
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
          String title = projectData['title'] ?? 'No Title';
          String description = projectData['description'] ?? 'No Description Available';
          String status = projectData['status'] ?? 'No Status';
          DateTime startDate = (projectData['start_date'] ?? Timestamp.now()).toDate();
          DateTime endDate = (projectData['end_date'] ?? Timestamp.now()).toDate();
          List<dynamic> files = projectData['files'] ?? [];
          String userId = projectData['user_id'] ?? 'Unknown User';

          String formattedStartDate = startDate.toLocal().toString().split(' ')[0];
          String formattedEndDate = endDate.toLocal().toString().split(' ')[0];

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }

              String uploaderName = 'Unknown Uploader';
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                uploaderName = userSnapshot.data!['fullName'] ?? 'Unknown Uploader';
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Header with Status
                    _buildProjectHeader(title, status, theme),
                    
                    SizedBox(height: 20),
                    
                    // Project Image Gallery
                    if (files.isNotEmpty) 
                      _buildImageGallery(files, theme),
                    
                    SizedBox(height: 30),
                    
                    // Project Details Card
                    _buildProjectDetailsCard(
                      description: description,
                      startDate: formattedStartDate,
                      endDate: formattedEndDate,
                      uploaderName: uploaderName,
                      theme: theme,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Action Buttons
                    _buildActionButtons(context, theme),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProjectHeader(String title, String status, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            color: _getStatusColor(status, theme),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
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

  Widget _buildImageGallery(List<dynamic> files, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Gallery',
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
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    files[index],
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

  Widget _buildProjectDetailsCard({
    required String description,
    required String startDate,
    required String endDate,
    required String uploaderName,
    required ThemeProvider theme,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: theme.isDarkTheme ? darkCardColor : lightCardColor,
      child: Padding(
        padding: EdgeInsets.all(20),
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
              'Project Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 15),
            
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
            
            Divider(
              color: theme.isDarkTheme ? Colors.grey[700] : Colors.grey[300],
              height: 30,
            ),
            
            // Uploader Info
            _buildDetailItem(
              icon: Icons.person,
              title: 'Uploaded by',
              content: uploaderName,
              theme: theme,
            ),
          ],
        ),
      ),
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
        SelectableText(
          content,
          style: TextStyle(
            color: theme.isDarkTheme ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeProvider theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.message),
            label: Text('Contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.isDarkTheme ? Colors.blue[800] : Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Contact action
            },
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.edit),
            label: Text('Edit Project'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.isDarkTheme ? Colors.white : Colors.black, padding: EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(
                color: theme.isDarkTheme ? Colors.grey[600]! : Colors.grey[400]!,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Edit action
            },
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