import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/auth/auth_screen.dart';
import 'package:myflutterfi/screens/features_screeen/about_us.dart';
import 'package:myflutterfi/screens/features_screeen/categories.dart';
import 'package:myflutterfi/screens/features_screeen/developers/developers.dart';
import 'package:myflutterfi/screens/features_screeen/projects/projects.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/profile_screen.dart';
import 'package:myflutterfi/screens/user/user_panel.dart';
import 'package:myflutterfi/screens/admin/admin_panel.dart';
import 'package:provider/provider.dart';

class CustomDrawers extends StatelessWidget {
  final bool showSignUpButton;

  const CustomDrawers({Key? key, required this.showSignUpButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final theme = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: theme.isDarkTheme ? darkCardColor : lightBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Fetch user details from Firestore if user is logged in
          currentUser != null
              ? FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: theme.isDarkTheme
                              ? darkCardColor
                              : Colors.white,
                        ),
                        accountName: Text('Loading...'),
                        accountEmail: Text('Please wait...'),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://www.example.com/default-avatar.png',
                          ),
                        ),
                      );
                    }

                    var userData = snapshot.data!;
                    var displayName = userData['fullName'] ?? 'No Name';
                    var email = userData['email'] ?? 'No Email';
                    var photoURL = userData['avatarUrl'] ??
                        'https://www.example.com/default-avatar.png';

                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: theme.isDarkTheme
                            ? darkCardColor
                            : Colors.white,
                      ),
                      accountName: Text(displayName),
                      accountEmail: Text(email),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          // Open a dialog to show the full image and allow editing
                          _showImageDialog(context, photoURL);
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoURL),
                        ),
                      ),
                    );
                  },
                )
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.isDarkTheme ? darkCardColor : Colors.white,
                  ),
                  accountName: Text('Guest'),
                  accountEmail: Text('Not logged in'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://www.example.com/default-avatar.png',
                    ),
                  ),
                ),
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          ListTile(
            title: Text('Categories'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => CategoriesPage()));
            },
          ),
          ListTile(
            title: Text('Developers'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DevelopersPage()));
            },
          ),
          ListTile(
            title: Text('Projects'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ProjectsPage()));
            },
          ),
          ListTile(title: Text('Contact Us'), onTap: () {}),
          if (currentUser != null) ...[
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: SpinKitFadingCircle(
            color: Colors.white, // Set the color of the spinner
            size: 50.0, // Set the size of the spinner
          ),
                  );
                }
                var userRole = snapshot.data!['role'];
                return ListTile(
                  title: Text(
                    userRole == 'Admin' ? 'Admin Panel' : 'User Panel',
                  ),
                  onTap: () {
                    if (userRole == 'Admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminHomePage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UserPanel()),
                      );
                    }
                  },
                );
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ] else if (showSignUpButton) ...[
            ListTile(
              title: Text('Login/Signup'),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AuthScreen()));
              },
            ),
          ],
        ],
      ),
    );
  }

  // Method to show the full image in a dialog with an edit button
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content:     Image.network(imageUrl),
          actions: [
            // Close button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
