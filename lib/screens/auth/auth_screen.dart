import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/auth/login_screen.dart';
import 'package:myflutterfi/screens/auth/role_page.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_button.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar:
          isMobile
              ? CustomMobileAppBar(
                showSignUpButton: false,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: false,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: false), // Custom Drawer widget,
      body: Container(
        decoration: BoxDecoration(
          gradient:
              theme.isDarkTheme
                  ? darkbackground_color()
                  : lightbackground_color(),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon
                Icon(Icons.lock_outline, size: 100, color: Colors.white),
                SizedBox(height: 20),
                // Welcome Text
                Text(
                  'Welcome to MyApp',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please sign in or sign up to continue',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sign In Button
                    CustomTextButton(
                      fontSize: 30,
                      label: 'SignUp',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RolePage()),
                        );
                      },
                      textColor: Colors.white,
                    ),
                    // Custom Divider (Line)
                    Container(
                      height: 60, // Height of the line (adjust as needed)
                      width:
                          1, // Width of the line (adjust thickness as needed)
                      color: Colors.white, // Color of the line
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // Add space around the line
                    ),
                    // Sign Up Button
                    CustomTextButton(
                      fontSize: 30,
                      label: 'SignIn',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
