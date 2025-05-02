import 'package:flutter/material.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onChanged;
  final String? hint;
  final Function(String?)? validator;
  final bool isHome; // isHome as non-nullable for clarity

  CustomDropdown({
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
    this.hint,
    this.validator,
    this.isHome = true, // Default to true if not passed
  });

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);

    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust dropdown width based on screen size
    double dropdownWidth = screenWidth < 360 ? screenWidth * 0.8 : screenWidth * 0.4;
    double fontSize = screenWidth < 360 ? 14 : 16; // Adjust font size for smaller screens
    double contentPadding = screenWidth < 360 ? 8 : 12; // Adjust padding for smaller screens

    List<DropdownMenuItem<String>> dropdownItems = categories.map((category) {
      return DropdownMenuItem<String>( 
        value: category,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: contentPadding),
          child: Text(
            category,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
            ),
          ),
        ),
      );
    }).toList();

    // Conditionally add the 'Create New Category' option if isHome is true
    if (isHome) {
      dropdownItems.add(
        DropdownMenuItem<String>(
          value: 'create_new',
          child: Text(
            'Create New Category',
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
      );
    }

    // Handle special case where selectedCategory is 'create_new'
    // Check that 'create_new' value is not passed as selectedCategory
    String? validSelectedCategory = selectedCategory == 'create_new' 
        ? null 
        : selectedCategory;

    return Container(
      width: dropdownWidth, // Adjust width dynamically based on screen size
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        color: theme.isDarkTheme
            ? darkBackTxtFieldColor
            : lightbacktxtfieldColor, // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: contentPadding),
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(20),
          dropdownColor:
              theme.isDarkTheme ? Colors.white : lightbacktxtfieldColor,
          value: validSelectedCategory ?? selectedCategory, // Avoid 'create_new' causing conflicts
          hint: hint != null
              ? Text(
                  hint!,
                  style: myStyle(
                    fontSize,
                    theme.isDarkTheme
                        ? darkPrimaryTextColor
                        : lightprimarytextColor,
                  ),
                )
              : null,
          onChanged: onChanged,
          isExpanded: true, // Makes the dropdown button take up the full width
          underline: SizedBox(), // Removes the default underline
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.deepPurple, // Icon color
          ),
          style: TextStyle(
            color: Colors.black, // Text color
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
          items: dropdownItems, // Use the modified list of items
        ),
      ),
    );
  }
}
