import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, // Set brightness to light
  primaryColor: Color.fromARGB(201, 252, 163, 193), // Primary app bar color
  hintColor: Colors.deepPurple, // Accent color for elements
  scaffoldBackgroundColor: Colors.white, // Main background color for screens
  cardColor: Color.fromRGBO(255, 255, 255, 0.9), // Card background color
  shadowColor: Color.fromRGBO(0, 0, 0, 0.1), // Light shadow for cards
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Primary text color
    bodyMedium: TextStyle(color: Colors.grey[700]), // Secondary text color
    titleLarge: TextStyle(color: Colors.black), // AppBar title color
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color.fromRGBO(245, 245, 245, 1), // Text field background
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Border color
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(201, 252, 163, 193)), // Focused border color
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromARGB(201, 252, 163, 193), // Primary button color
    textTheme: ButtonTextTheme.primary, // Button text color
  ),
);
