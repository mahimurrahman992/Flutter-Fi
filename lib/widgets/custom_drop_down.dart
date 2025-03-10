import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onChanged;

  CustomDropdown({
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme
    final theme = Provider.of<ThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(border: Border.all(width: 0.3),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(20),
          dropdownColor:
              theme.isDarkTheme ? Colors.white : lightbacktxtfieldColor,
          value: selectedCategory,
          hint: Text(
            'Select Category',
            style:myStyle(18,  theme.isDarkTheme?darkPrimaryTextColor:lightprimarytextColor),
          ),
          onChanged: onChanged,
          isExpanded: true, // Makes the dropdown button take up the full width
          underline: SizedBox(), // Removes the default underline
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.deepPurple, // Icon color
          ),
          style: TextStyle(
            color: Colors.black, // Text color
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
