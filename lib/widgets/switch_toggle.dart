import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart'; // Import ThemeProvider

class ThemeToggleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon representing the theme (sun/moon)
        Icon(
          theme.isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny, // Change icon based on the theme
          color: theme.isDarkTheme ? Colors.white : Colors.yellow, // Icon color changes based on theme
          size: 30.0, // Icon size
        ),
        // Switch to toggle the theme
        Switch(
          value: theme.isDarkTheme, // Set the value based on the current theme
          onChanged: (bool newValue) {
            // Toggle the theme
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          activeColor: Colors.white, // Active color when dark theme is on
          activeTrackColor: Colors.black, // Track color when dark theme is on
          inactiveThumbColor: Colors.white, // Thumb color when light theme is on
          inactiveTrackColor: Color.fromARGB(201, 252, 163, 193), // Track color when light theme is on
        ),
      ],
    );
  }
}
