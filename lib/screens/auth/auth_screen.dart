import 'package:flutter/material.dart';

import 'package:test_flutter_fi/screens/auth/login_screen.dart';
import 'package:test_flutter_fi/screens/auth/role_page.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';
import 'package:test_flutter_fi/widgets/custom_button.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showSignUpButton: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.purple.shade600],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon
                Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Colors.white,
                ),
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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
                        textColor: Colors.white),
                    // Custom Divider (Line)
                    Container(
                      height: 60, // Height of the line (adjust as needed)
                      width:
                          1, // Width of the line (adjust thickness as needed)
                      color: Colors.white, // Color of the line
                      margin: EdgeInsets.symmetric(
                          horizontal: 20), // Add space around the line
                    ),
                    // Sign Up Button
                    CustomTextButton(
                        fontSize: 30,
                        label: 'SignIn',
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        textColor: Colors.white)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
