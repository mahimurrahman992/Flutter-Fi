import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/screens/auth/signup_screen.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';
import 'package:test_flutter_fi/widgets/custom_button.dart';

class RolePage extends StatefulWidget {
  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  String _role = 'User';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        showSignUpButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: theme.isDarkTheme
                ? darkbackground_color()
                : lightbackground_color()),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select your role:',
                style: myStyle(
                    18,
                    theme.isDarkTheme
                        ? darkPrimaryTextColor
                        : lightprimarytextColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _role = 'Admin';
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: 500.h,
                    width: 150.w,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _role == 'Admin'
                          ? Colors.white54
                          : Colors.transparent,
                      border: Border.all(
                          color:
                              theme.isDarkTheme ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: myStyle(
                              22,
                              _role == 'Admin' ? Colors.black : Colors.white,
                              FontWeight.w700),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '''
• User Management: Options to view users, change roles, and manage profiles.
• Content Management: Areas for blog and comment moderation, with edit/delete options.
• Project Management: A dashboard showing the status of different projects and tasks.
• Media Management: Interface for uploading, viewing, and deleting media files.
• Theme and Settings: Options for toggling themes and changing application settings.
  ''',
                          style: myStyle(18,
                              _role == 'Admin' ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _role = 'User';
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: 500.h,
                    width: 150.w,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color:
                          _role == 'User' ? Colors.white54 : Colors.transparent,
                      border: Border.all(
                          color:
                              theme.isDarkTheme ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'User',
                          style: myStyle(
                              22,
                              _role == 'User' ? Colors.black : Colors.white,
                              FontWeight.w700),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '''
• Browse Content: View blogs, read articles, and comment on posts.
• User Profile Management: Create and manage your profile, update preferences.
• Engage with Content: Like, share, and comment on blogs to engage with the community.
• Notifications: Receive updates, news, and manage notification settings.
• Interact with Media: View and upload images, videos, and other media content.
• Theme Personalization: Choose between light or dark themes for your preference.
• Explore Projects: View, follow, and get updates on various ongoing projects.
  ''',
                          style: myStyle(18,
                              _role == 'User' ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CustomTextButton(
              label: 'Signup',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(
                        role: _role,
                      ),
                    ));
              },
              fontSize: 22,
              textColor: Colors.white,
              top: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
                child: Text(
                  'Already have an account?, Login here',
                  style: myStyle(18, Colors.white, FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}
