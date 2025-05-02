import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?) validator;
  final IconButton? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool isContent; // New boolean variable to determine if it's content input
final double? width; // New optional parameter for width
  const CustomTextField({
    this.hintText,
    Key? key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.suffixIcon,
    this.obscureText = false, // Optional parameter to control text visibility
    this.keyboardType, // Default keyboard type
    this.isContent = false, // This will control whether multiline is allowed
    this.width, // This will control the width of the text field
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust font size, padding, and border radius based on screen size
    double fontSize = screenWidth < 360 ? 14 : 16; // Adjust font size for smaller screens
    double contentPadding = screenWidth < 360 ? 8 : 12; // Adjust content padding for smaller screens
    double borderRadius = screenWidth < 360 ? 15 : 20; // Adjust border radius for smaller screens
double fieldWidth = widget.width ?? screenWidth ; // Default to 90% of the screen width if no width is provided
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02), // Dynamic padding based on screen height
      child: Container(width: fieldWidth, // Set the width dynamically based on the passed value or default
        child: TextFormField(
          obscureText: widget.obscureText, // Use the obscureText parameter for password field visibility
          controller: widget.controller,
          keyboardType: widget.keyboardType, // Set the keyboard type here
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: myStyle(fontSize, theme.isDarkTheme ? Colors.white : darkHintTxtColor, FontWeight.w700),
            hintText: widget.hintText,
            hintStyle: myStyle(fontSize + 2, theme.isDarkTheme ? Colors.white : darkHintTxtColor),
            filled: true,
            fillColor: theme.isDarkTheme
                ? darkBackTxtFieldColor
                : lightbacktxtfieldColor,
            contentPadding: EdgeInsets.symmetric(vertical: contentPadding, horizontal: contentPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.isDarkTheme
                    ? lighttxtfieldborderColor
                    : darkTxtFieldBorderColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: theme.isDarkTheme
                    ? lighttxtfieldfocusborderColor
                    : darkTxtFieldFocusBorderColor,
                width: 2,
              ),
            ),
            suffixIcon: widget.suffixIcon, // Use the suffixIcon parameter
          ),
          validator: widget.validator,
          minLines: 1, // Always start with 1 line
          maxLines: widget.isContent ? null : 1, // If it's content input, allow multiline, otherwise set to 1 line
        ),
      ),
    );
  }
}
