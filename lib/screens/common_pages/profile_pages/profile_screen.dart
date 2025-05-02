
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/project_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/own_projects/project_details.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/own_projects/project_upload.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_button.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _uploadImage(Uint8List imageBytes) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    setState(() => _isUploading = true);

    try {
      // Include user ID in the path
      final String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars/${currentUser.uid}/$fileName');

      final UploadTask uploadTask = storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/png'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'avatarUrl': downloadUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated successfully!')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('Upload error: $e');
    }
  }

  Future<void> _pickImage() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in first')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        await _uploadImage(bytes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    User? currentUser = _auth.currentUser;
    final theme = Provider.of<ThemeProvider>(context);
    bool isMobile = width < 800;

    if (currentUser == null) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: isMobile
            ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey,
              )
            : CustomAppBar(showSignUpButton: true),
        body: Center(child: Text('No user logged in')),
      );
    }

    return Scaffold(
      backgroundColor:
          theme.isDarkTheme ? darkBackgroundColor : lightBackgroundColor,
      key: _scaffoldKey,
      appBar: isMobile
          ? CustomMobileAppBar(
              showSignUpButton: true,
              scaffoldKey: _scaffoldKey,
            )
          : CustomAppBar(showSignUpButton: true),
      drawer: CustomDrawers(showSignUpButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Info
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var userData = snapshot.data!;
                  String? avatarUrl = userData['avatarUrl'];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name: ${userData['fullName'] ?? 'No Name'}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            _isUploading
                                ? CircleAvatar(
                                    radius: 80,
                                    child: CircularProgressIndicator(),
                                  )
                                : CircleAvatar(
                                    radius: 80,
                                    backgroundColor:
                                        Colors.grey[200], // Fallback color
                                    backgroundImage: avatarUrl != null
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    child: avatarUrl == null
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                stream: Provider.of<ProjectProvider>(
                  context,
                ).getProjects(currentUser.uid),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!projectSnapshot.hasData ||
                      projectSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No projects available.'));
                  }

                  var projects =
                      projectSnapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return Card(
                      color: theme.isDarkTheme
                          ? darkCardColor
                          : lightCardColor,
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          data['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['status'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              data['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
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

                  return ListView(shrinkWrap: true, children: projects);
                },
              ),

              SizedBox(height: 20),

              // Add Project Button at the Bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomTextButton2(
                  label: 'Add Projects',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectUploadForm(userId: currentUser.uid),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
