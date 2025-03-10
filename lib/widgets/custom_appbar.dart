import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/slide_controller.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/screens/admin/admin_panel.dart';
import 'package:test_flutter_fi/screens/auth/auth_screen.dart';

import 'package:test_flutter_fi/screens/features_screeen/about_us.dart';
import 'package:test_flutter_fi/screens/features_screeen/categories.dart';
import 'package:test_flutter_fi/screens/features_screeen/developers/developers.dart';

import 'package:test_flutter_fi/screens/common_pages/profile_pages/profile_screen.dart';
import 'package:test_flutter_fi/screens/features_screeen/projects/projects.dart';
import 'package:test_flutter_fi/screens/user/user_panel.dart';
import 'package:test_flutter_fi/widgets/custom_button.dart';
import 'package:test_flutter_fi/widgets/gradient_text.dart';
import 'package:test_flutter_fi/widgets/switch_toggle.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSignUpButton;

  const CustomAppBar({super.key, required this.showSignUpButton});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
    return AppBar(
      toolbarHeight: 110,
      leading: GestureDetector(
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
              context.read<SlideController>().toggleContainer('Contact Us');
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
