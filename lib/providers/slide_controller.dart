import 'package:flutter/material.dart';

class SlideController extends ChangeNotifier {
  bool _isContainerVisible = false;
  String _selectedSection = ''; // Track the selected section

  bool get isContainerVisible => _isContainerVisible;
  String get selectedSection => _selectedSection;

  // Toggle the visibility of the container and update the section
  void toggleContainer(String section) {
    if (_selectedSection == section) {
      _isContainerVisible = !_isContainerVisible; // If the same section is clicked, toggle visibility
    } else {
      _selectedSection = section; // Set the new section
      _isContainerVisible = true; // Always show the container when a new section is selected
    }
    notifyListeners();
  }
}
