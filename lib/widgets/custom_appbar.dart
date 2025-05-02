import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/styles.dart';

import 'package:myflutterfi/screens/admin/admin_panel.dart';
import 'package:myflutterfi/screens/auth/auth_screen.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/profile_screen.dart';
import 'package:myflutterfi/screens/features_screeen/about_us.dart';
import 'package:myflutterfi/screens/features_screeen/categories.dart';
import 'package:myflutterfi/screens/features_screeen/developers/developers.dart';
import 'package:myflutterfi/screens/features_screeen/projects/projects.dart';
import 'package:myflutterfi/screens/user/user_panel.dart';
import 'package:myflutterfi/widgets/gradient_text.dart';
import 'package:myflutterfi/widgets/switch_toggle.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSignUpButton;

  const CustomAppBar({super.key, required this.showSignUpButton});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;


    return AppBar(
      toolbarHeight: 110,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Image.asset(
          'images/flutter.png',
          fit: BoxFit.contain,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AboutUsPage(),
              ));
            },
            child: Text(
              'About Us',
              style: myStyle(18, Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoriesPage(),
              ));
            },
            child: Text(
              'Categories',
              style: myStyle(18, Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DevelopersPage(),
              ));
            },
            child: Text(
              'Developers',
              style: myStyle(18, Colors.white),
            ),
          ), // Projects Button (added here)
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProjectsPage(),
              ));
            },
            child: Text(
              'Projects',
              style: myStyle(18, Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
          
            },
            child: Text(
              'Contact Us',
              style: myStyle(18, Colors.white),
            ),
          ),
        ],
      ),
      actions: [
        // Theme toggle button
      ThemeToggleSwitch(),
        if (currentUser != null) ...[
          // Fetch user role from Firestore
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              var userRole =
                  snapshot.data!['role']; // Get the role from Firestore

              // Show the appropriate button based on user role
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the respective panel based on the role
                      if (userRole == 'Admin') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AdminHomePage()));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UserPanel()));
                      }
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      backgroundColor:
                          Colors.transparent, // No background for TextButton
                      // Optionally, you can set additional styling like border, padding, etc.
                    ),
                    child: GradientText2(
                      // Using GradientText here
                      text: userRole == 'Admin' ? 'Admin Panel' : 'User Panel',
                      fontSize: 18.0, // Set the desired font size
                      fw: FontWeight.bold, // Set the desired font weight
                    ),
                  ));
            },
          ),

          // Profile Button
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),

          // Sign Out Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 20), // Padding for the button
                backgroundColor: Colors.transparent, // Transparent background
                // Optionally, you can set other styles like border, etc.
              ),
              child: GradientText2(
                // Use GradientText inside the button
                text: 'Sign Out', // The text that will have the gradient effect
                fontSize: 18.0, // Set the desired font size
                fw: FontWeight.bold, // Set the desired font weight
              ),
            ),
          )
        ] else if (showSignUpButton) ...[
          // Show Login/Signup button if the user is not logged in
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuthScreen(),
                ));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 20), // Adjust padding as needed
                backgroundColor:
                    Colors.transparent, // No background color for TextButton
                // You can add additional styles like border if needed
              ),
              child: GradientText2(
                // Use GradientText widget inside the button
                text: 'Login/Signup', // The text with the gradient effect
                fontSize: 18.0, // Font size
                fw: FontWeight.bold, // Font weight
              ),
            ),
          )
        ]
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(201, 252, 163, 193), Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}


/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/widgets/gradient_text.dart';
import 'package:myflutterfi/widgets/switch_toggle.dart';
import 'package:myflutterfi/screens/admin/admin_panel.dart';
import 'package:myflutterfi/screens/auth/auth_screen.dart';
import 'package:myflutterfi/screens/common_pages/profile_pages/profile_screen.dart';
import 'package:myflutterfi/screens/features_screeen/about_us.dart';
import 'package:myflutterfi/screens/features_screeen/categories.dart';
import 'package:myflutterfi/screens/features_screeen/developers/developers.dart';
import 'package:myflutterfi/screens/features_screeen/projects/projects.dart';
import 'package:myflutterfi/screens/user/user_panel.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSignUpButton;

  const CustomAppBar({super.key, required this.showSignUpButton});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    // Get the screen width to determine layout
    double screenWidth = MediaQuery.of(context).size.width;

    // Decide spacing based on screen width (PC, Tablet, Mobile)
    double buttonSpacing = screenWidth > 800 ? 5 : 3.0;  // More space on large screens

    return AppBar(
      toolbarHeight: 110,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Image.asset(
          'images/flutter.png',
          fit: BoxFit.contain,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildTextButton(context, 'About Us', AboutUsPage(), buttonSpacing),
          _buildTextButton(context, 'Categories', CategoriesPage(), buttonSpacing),
          _buildTextButton(context, 'Developers', DevelopersPage(), buttonSpacing),
          _buildTextButton(context, 'Projects', ProjectsPage(), buttonSpacing),
          _buildTextButton(context, 'Contact Us', null, buttonSpacing),
        ],
      ),
      actions: [
        ThemeToggleSwitch(),
        if (currentUser != null) ...[
          _buildRoleBasedNavigation(context, currentUser),
          _buildTextButton(context, 'Profile', ProfilePage(), buttonSpacing),
          _buildSignOutButton(context, buttonSpacing),
        ] else if (showSignUpButton) ...[
          _buildTextButton(context, 'Login/Signup', AuthScreen(), buttonSpacing),
        ],
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(201, 252, 163, 193), Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String label, Widget? page, double spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: TextButton(
        onPressed: page != null
            ? () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
              }
            : () {
                // Handle Contact Us
              },
        child: Text(
          label,
          style: myStyle(18, Colors.white),
        ),
      ),
    );
  }

  Widget _buildRoleBasedNavigation(BuildContext context, User currentUser) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userRole = snapshot.data!['role'];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              if (userRole == 'Admin') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHomePage()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserPanel()));
              }
            },
            child: GradientText2(
              text: userRole == 'Admin' ? 'Admin Panel' : 'User Panel',
              fontSize: 18.0,
              fw: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context, double spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: GradientText2(
          text: 'Sign Out',
          fontSize: 18.0,
          fw: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
 */