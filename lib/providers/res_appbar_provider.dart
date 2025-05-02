import 'package:flutter/material.dart';

class ResponsiveAppBarProvider with ChangeNotifier {
  bool isMobile = false;

  // Method to update screen size type (Mobile/PC)
  void updateAppBarType(double width) {
    // If the screen width is smaller than 800px, it's considered mobile.
    isMobile = width < 800;
    notifyListeners();
  }

  bool get isMobileAppBar => isMobile;
}
